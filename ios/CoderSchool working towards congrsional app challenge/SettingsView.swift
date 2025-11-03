import SwiftUI
import Combine
import AuthenticationServices
import DeviceActivity
import FamilyControls
import UserNotifications

@MainActor
class AppUsageTracker: ObservableObject {
    @Published var activeApp: CustomApp? = nil
    private var startTime: Date? = nil

    func appIsActive(_ app: CustomApp?) {
        if app?.id != activeApp?.id {
            activeApp = app
            startTime = Date()
        }
    }

    func timeOnCurrentApp() -> TimeInterval {
        guard let start = startTime else { return 0 }
        return Date().timeIntervalSince(start)
    }
}

struct Reminder {
    let timeInterval: TimeInterval
    let messages: [String]
}

let reminders: [Reminder] = [
    
    // When they get on the app 
    Reminder(timeInterval: 0*60, messages: ["Hey! Before you spend time on this app, remember your goals.","Remember: It's easier to stop before you start. Maybe you should consider leaving this app?","Let's not spend too much time on this app - let's choose productivity today!"]),
    
    
    // 10 minutes
    Reminder(timeInterval: 10*60, messages: [
        "You have been on this app for 10 minutes. If you pause now you are more likely to complete your goals.",
        "Remember your goals! Let's close this app soon.",
        "You spent 10 minutes on this app. In that time, you could have taken a quick walk outside."
    ]),
    // 30 minutes
    Reminder(timeInterval: 30*60, messages: [
        "You've spent 30 minutes on this app. Let's try taking a break from your phone.",
        "Are there better things you could be doing with your time? Let's stay on track.",
        "Take a deep breath. 30 minutes is a long time, let's take a pause."
    ]),
    // 60 minutes
    Reminder(timeInterval: 60*60, messages: [
        "Wow! You spent an hour on this app. How about stepping away for a little bit?",
        "You have been on this app for 60 minutes, that's enough time to walk 3 miles! It's never too late to take a pause.",
        "In 1 hour the Sun emits enough energy to power the Earth for a year! So what have you done with your hour?"
    ])
]

class AppReminderManager {
    private var sentReminders: Set<Int> = []
    private var timer: Timer?
    private let tracker: AppUsageTracker
    private let reminders: [Reminder]

    init(tracker: AppUsageTracker, reminders: [Reminder]) {
        self.tracker = tracker
        self.reminders = reminders
    }

    @MainActor
    func startMonitoring() {
        // Use closure-based timer to avoid selector issues and ObjC exposure
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.checkAndSendReminder()
            }
        }
        Task { @MainActor in
            await checkAndSendReminder()
        }
    }

    @MainActor
    private func checkAndSendReminder() {
        guard let app = tracker.activeApp else { return }
        let timeSpent = tracker.timeOnCurrentApp()

        for (index, reminder) in reminders.enumerated() {
            if timeSpent >= reminder.timeInterval && !sentReminders.contains(index) {
                if let randomMessage = reminder.messages.randomElement() {
                    sendNotification(for: app.name, message: randomMessage)
                    sentReminders.insert(index)
                }
            }
        }
    }

    private func sendNotification(for appName: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "UNSCROLL: Screen Time Reminder"
        content.body = "\(message) (\(appName))"
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    func resetReminders() {
        sentReminders.removeAll()
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
} // <-- important: close AppReminderManager here so the rest of the types are top-level


// MARK: - ScreenTimeManager
@MainActor
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    let DAMcenter = DeviceActivityCenter()
    private let center = AuthorizationCenter.shared
    private let notifCenter = UNUserNotificationCenter.current()
    
    @Published var selection = FamilyActivitySelection() //var that actually stores the selected apps, binding allowes for picker to be updated live

    @Published var isAuthorized = false
    @Published var isNotificationAuthorized = false
    
    private static let savedSelectionKey = "SavedFamilyActivitySelection" //key used to save/selction in userdefaults
    
    @Published var restrictedApps: [RestrictedApp] = [] {
        didSet{
            saveRestrictedApps()
        }
    }
    //@Binding var newRestrictedApp: RestrictedApp
    
    init() {
        Task {
            loadRestrictedApps()
            await updateAuthorizationStatus()
            
        }
        //loadSelection()
    }

   
    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            await updateAuthorizationStatus()
            print("Request sent successfully!")
        } catch {
            print("Authorization error: \(error.localizedDescription)")
        }
    }
    func updateAuthorizationStatus() async {
        let status = center.authorizationStatus
        isAuthorized = (status == .approved)
        print("Screen Time authorization status: \(status.rawValue)")
        
        await notifCenter.getNotificationSettings{settings in
            Task{ @MainActor in
                switch settings.authorizationStatus{
                case .authorized:
                    print("Notification authorized")
                    self.isNotificationAuthorized = true
                case .denied:
                    print("Notifications denied")
                    self.isNotificationAuthorized = false
                case .notDetermined:
                    print("Notifcations not determined")
                    self.requestNotificationPermission()
                case .provisional:
                    // Provisional authorization granted (can send notifications silently).
                    print("Notification authorization: Provisional")
                case .ephemeral:
                    // Ephemeral authorization granted (for app clips).
                    print("Notification authorization: Ephemeral")
                @unknown default:
                    self.isNotificationAuthorized = false
                }
            }
            
        }
        
    }
    
    
//    func saveSelection(selection:FamilyActivitySelection) { // turnes apps selcted into code so can save and stores it in userdefaults
//        do {
//            let data = try PropertyListEncoder().encode(selection)
//            UserDefaults.standard.set(data, forKey: restrictedapp.name)
//        } catch {
//            print("Failed to save FamilyActivitySelection:", error)
//        }
//    }

//    func loadSelection(restrictedapp:RestrictedApp) { // takes the saved from UserDefaults then decodes it so it can be displayed to user
//        guard let data = UserDefaults.standard.data(forKey: restrictedapp.name) else { return }
//        do {
//            let saved = try PropertyListDecoder().decode(RestrictedApp.self, from: data)
//            selection = saved.selection
//        } catch {
//            print("Failed to load FamilyActivitySelection:", error)
//        }
//    }
    
    func startMonitoring(app:RestrictedApp, goalLimit: Float)-> Bool{
        
        let warning = (Float(app.threshold) - goalLimit) - 0.25

        // Check to make sure warning is not less then 0
        if warning < 0 && app.threshold != 0 {
            return false
        }
        let warningMinutes = max(Int(warning * 60), 0)
        let threshold = (Float(app.threshold) - goalLimit)

        let activityName = DeviceActivityName("\(app.name)")
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour:0, minute:0),
                                              intervalEnd: DateComponents(hour:23, minute:59),
                                              repeats: true,
                                              warningTime:DateComponents(minute:warningMinutes))
        guard let tokens = app.tokens, !tokens.isEmpty else{
            return false
        }
        
        // Use the unwrapped constant
        let event = DeviceActivityEvent(applications:tokens, threshold:DateComponents(minute:Int(threshold * 60)))
        let eventName = DeviceActivityEvent.Name("\(app.name)")
        do{
            print("Attempting to start monitoring")
            print(warningMinutes)
            print(goalLimit)
            print(threshold)
            print(app.threshold)
            try DAMcenter.startMonitoring(activityName, during: schedule, events: [eventName: event])
            print("Successfully starte monitoring")
            return true
        }catch{
            print("Error starting monitoring: \(error)")
            return false
        }
    }
    
    func stopMonitoring(appName:String){
        print("Stopping the monitoring")
        let activityName = DeviceActivityName(appName)
       DAMcenter.stopMonitoring([activityName])
    }
    func stopAllMonitoring(){
        print("Stopping all monitoring")
        DAMcenter.stopMonitoring()
    }
    
    func requestNotificationPermission() {
        notifCenter.getNotificationSettings { settings in
            print("Authorization status: \(settings.authorizationStatus.rawValue)")
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.isNotificationAuthorized = true
                print("Notification permission granted")
            } else {
                print("Notification permission denied")

            }
        }
    }
    
    func scheduleNotification () async {
        let content = UNMutableNotificationContent()
        content.title = "Screen Time Notification"
        content.body = "Screen time notification"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger:trigger )
        
        do {
            print("Trying to send notification")
            try await notifCenter.add(request)
        }catch{
            print("Error creating notification \(error)")
        }
    }
    
    func saveRestrictedApps() {
        if let encoded = try? JSONEncoder().encode(restrictedApps) {
            UserDefaults.standard.set(encoded, forKey: "restrictedApps")
        }
    }

    func loadRestrictedApps() {
        if let savedData = UserDefaults.standard.data(forKey: "restrictedApps"),
           let decoded = try? JSONDecoder().decode([RestrictedApp].self, from: savedData) {
            restrictedApps = decoded
        }
    }
    func deleteApp(at offsets: IndexSet) {
        restrictedApps.remove(atOffsets: offsets)
    }
    
}

// MARK: - iTunes response models
struct ItunesApp: Decodable {
    let trackId: Int
    let trackName: String
    let artworkUrl100: String
}

struct ItunesSearchResponse: Decodable {
    let results: [ItunesApp]
}

class CustomAppsViewModel: ObservableObject {
    static let shared = CustomAppsViewModel()
    
    @Published var searchText = ""
    @Published var searchResults: [CustomApp] = []
    @Published var selectedApps: [CustomApp] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
       // loadSelectedApps()

//        $searchText
//            .removeDuplicates()
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .sink { [weak self] text in
//                if text.isEmpty {
//                    self?.searchResults = []
//                } else {
//                    self?.searchApps(query: text)
//                }
//            }
//            .store(in: &cancellables)
    }

    func searchApps(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(encodedQuery)&entity=software&limit=20"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let decoded = try JSONDecoder().decode(ItunesSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    let newApps = decoded.results.map {
                        CustomApp(id: String($0.trackId), name: $0.trackName, appIcon: $0.artworkUrl100)
                    }
                    self?.searchResults = newApps.filter { app in
                        !(self?.selectedApps.contains(app) ?? false)
                    }
                }
            } catch {
                print("Failed to decode search results: \(error)")
            }
        }.resume()
    }

//    func saveSelectedApps() {
//        if let encoded = try? JSONEncoder().encode(selectedApps) {
//            UserDefaults.standard.set(encoded, forKey: "customApps")
//        }
//    }
//
//    func loadSelectedApps() {
//        if let savedData = UserDefaults.standard.data(forKey: "customApps"),
//           let decoded = try? JSONDecoder().decode([CustomApp].self, from: savedData) {
//            selectedApps = decoded
//        }
//    }
//
//    func toggleRestriction(for app: CustomApp) {
//        if let index = selectedApps.firstIndex(of: app) {
//            selectedApps[index].isRestricted.toggle()
//            // reassign to trigger didSet persistence
//            selectedApps = selectedApps
//        }
//    }
//
//    func deleteApp(at offsets: IndexSet) {
//        selectedApps.remove(atOffsets: offsets)
//    }
}

struct SearchView: View {
    @EnvironmentObject var viewModel: CustomAppsViewModel
    @State private var recentlyAddedAppID: String? = nil
    @Binding var restrictedApp: RestrictedApp

    var body: some View {
        VStack {
            TextField("Search for apps...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit{
                    viewModel.searchApps(query: viewModel.searchText)
                }

            List {
                ForEach(viewModel.searchResults) { app in
                    HStack {
                        Text(app.name)
                        Spacer()
                        if recentlyAddedAppID == app.id {
                            Text("Selected!")
                                .foregroundColor(.green)
                                .transition(.scale)
                                .animation(.easeInOut, value: recentlyAddedAppID)
                        } else {
                            Button("Add") {
                                if !viewModel.selectedApps.contains(app) {
                                    withAnimation(.spring()) {
                                        viewModel.selectedApps.insert(app, at: 0)
                                        recentlyAddedAppID = app.id
                                        restrictedApp.customApp = app
                                    }

//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                        withAnimation {
//                                            recentlyAddedAppID = nil
//                                        }
//                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                            .scaleEffect(recentlyAddedAppID == app.id ? 1.1 : 1.0)
                        }
                    }
                }
            }.padding()
            Spacer()
            NavigationLink(value:NavigationDestinations.ValidateRestrictedAppView){
                ZStack{
                    Text("Continue")
                        .padding()
                        .font(.headline)
                        .foregroundStyle(.cyan)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .navigationTitle("Add Custom App")
        .background(.cyan)
    }
}

enum NavigationDestinations: String, CaseIterable, Hashable{
    case SearchView
    case RestrictedAppsView
    case ValidateRestrictedAppView
}

struct SettingsView: View {
    @StateObject private var viewModel = CustomAppsViewModel.shared
    @ObservedObject private var screenTimeManager = ScreenTimeManager.shared
    @AppStorage("IsLoggedIn") var isLoggedIn: Bool = true
    @State private var isPressed = false
    @State private var path = NavigationPath()
    let routes = NavigationDestinations.allCases
    @State var itunesSelection: CustomApp?
    @State var restrictedApp:RestrictedApp = RestrictedApp(name: "",customApp:CustomApp(id: "", name: "", appIcon: ""),threshold: 0,category:"Other")

    private func handleLogout() {
        isLoggedIn = false
        print("Logged out")
    }
    @State var selection: FamilyActivitySelection = FamilyActivitySelection()

    var body: some View {
        NavigationStack(path:$path) {
            VStack {
                Text("Settings")
                    .font(.custom("futura", size: 40))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                List {
                    Section(header: Text("User Info").font(.custom("futura", size: 25))
                        .foregroundColor(.white)) {
                            NavigationLink(destination: PersonalInfoView()) {
                                HStack {
                                    Text("Personal Info")
                                    Spacer()
                                    Text("Details").foregroundColor(.gray)
                                }
                            }

                            NavigationLink(destination: GoalsPageView()) {
                                HStack {
                                    Text("Change goals")
                                    Spacer()
                                    Text("Details").foregroundColor(.gray)
                                }
                            }
                            
                            if screenTimeManager.isAuthorized {
                                HStack {
                                    Text("Screen Time Access")
                                        .foregroundColor(.black)
                                        .font(.custom("futura", size: 15))
                                    
                                    Spacer()
                                    Text("Granted")
                                        .foregroundColor(.green)
                                        .font(.custom("futura", size: 15 ))
                                }
                            } else {
                                Button("Enable Screen Time Access") {
                                    Task {
                                        await screenTimeManager.requestAuthorization()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            if screenTimeManager.isNotificationAuthorized {
                                HStack {
                                    Text("Notification Access")
                                        .foregroundColor(.black)
                                        .font(.custom("futura", size: 15))
                                    
                                    Spacer()
                                    Text("Granted")
                                        .foregroundColor(.green)
                                        .font(.custom("futura", size: 15 ))
                                }
                            } else {
                                Button("Enable Notifcation Access") {
                                    Task {
                                        screenTimeManager.requestNotificationPermission()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            
                        }
                    
                    Section(header: Text("Limited-use Apps").font(.custom("futura", size: 25))
                        .foregroundColor(.white)) {
                            ForEach(screenTimeManager.restrictedApps, id:\.self) { app in
                                    HStack{
                                        AsyncImage(url: URL(string:app.customApp.appIcon)){image in
                                            image.resizable()
                                        } placeholder:{
                                            ProgressView() //display progressview while loading the icons
                                        }
                                            .frame(width:50,height:50)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        Text(app.name)
                                    
                                }
                            }
                            .onDelete(perform: screenTimeManager.deleteApp)
                            
                            NavigationLink(value:NavigationDestinations.RestrictedAppsView) {
                                    HStack {
                                        Text("Add new app")
                                        Spacer()
                                        Text("Details").foregroundColor(.gray)
                                    }
                            }
                        }
                        .environmentObject(viewModel)
                    
                    Section {
                        Button(action: handleLogout) {
                            Text("Logout")
                                .font(.custom("futura", size: 25))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .simultaneousGesture(
                            DragGesture(minimumDistance:0)
                                .onChanged { _ in isPressed = true }
                                .onEnded { _ in isPressed = false }
                        )
                    }
                    .listRowBackground(Color(.cyan))
//                    Section {
//                        Button(action: {
//                            Task{
//                                screenTimeManager.startMonitoring()
//                            }}) {
//                            Text("Start monitoring")
//                                .font(.custom("futura", size: 25))
//                                .foregroundColor(.white)
//                                .padding(.vertical, 10)
//                                .padding(.horizontal, 20)
//                                .background(Color.green)
//                                .cornerRadius(10)
//                        }
//                        .buttonStyle(.plain)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .simultaneousGesture(
//                            DragGesture(minimumDistance:0)
//                                .onChanged { _ in isPressed = true }
//                                .onEnded { _ in isPressed = false }
//                        )
//                    }
//                    .listRowBackground(Color(.cyan))
//                    Section {
//                        Button(action: {
//                            Task{
//                                screenTimeManager.stopMonitoring()
//                            }}) {
//                            Text("Stop monitoring")
//                                .font(.custom("futura", size: 25))
//                                .foregroundColor(.white)
//                                .padding(.vertical, 10)
//                                .padding(.horizontal, 20)
//                                .background(Color.orange)
//                                .cornerRadius(10)
//                        }
//                        .buttonStyle(.plain)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .simultaneousGesture(
//                            DragGesture(minimumDistance:0)
//                                .onChanged { _ in isPressed = true }
//                                .onEnded { _ in isPressed = false }
//                        )
//                        Button(action:{Task{
//                            let userD =  UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.string(forKey: "shouldShowAlert")
//                            print("\(userD)")
//                        }}){
//                            Text("Get User Defaults")
//                        }
//                        Button(action:{Task{
//                            await screenTimeManager.scheduleNotification()
//                        }}){
//                            Text("Get User Defaults")
//                        }
//                    }
//                    .listRowBackground(Color(.cyan))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.cyan)
            .navigationDestination(for: NavigationDestinations.self){route in
                switch route{
                case .SearchView:
                    SearchView(restrictedApp:$restrictedApp).environmentObject(viewModel)
                case .RestrictedAppsView:
                    RestrictedAppsView(restrictedApp:$restrictedApp, selection:$selection)
                case .ValidateRestrictedAppView:
                    ValidateRestrictedAppView(path:$path, restrictedApp:$restrictedApp, selection:$selection)
                }
            }
        }
    }
}

struct PersonalInfoView: View {
    @AppStorage("name") private var name = "User's name"
    @AppStorage("username") private var username = "User's username"
    @AppStorage("password") private var password = "User's password"

    @State private var isEditingName = false
    @State private var isEditingUsername = false
    @State private var isEditingPassword = false

    var body: some View {
        VStack {
            Text("Personal Info")
                .font(.custom("Futura", size: 40))
                .padding(.top, 20)

            Form {
                Section(header: Text("Name")) {
                    HStack {
                        if isEditingName {
                            TextField("Name", text: $name)
                        } else {
                            Text(name)
                        }
                        Spacer()
                        Button(isEditingName ? "Save" : "Edit") {
                            isEditingName.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Section(header: Text("Username")) {
                    HStack {
                        if isEditingUsername {
                            TextField("Username", text: $username)
                        } else {
                            Text(username)
                        }
                        Spacer()
                        Button(isEditingUsername ? "Save" : "Edit") {
                            isEditingUsername.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Section(header: Text("Password")) {
                    HStack {
                        if isEditingPassword {
                            TextField("Password", text: $password)
                        } else {
                            Text(password)
                        }
                        Spacer()
                        Button(isEditingPassword ? "Save" : "Edit") {
                            isEditingPassword.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
