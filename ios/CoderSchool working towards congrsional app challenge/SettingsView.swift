import SwiftUI
import Combine
import AuthenticationServices
import DeviceActivity
import FamilyControls

@MainActor
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    private let center = AuthorizationCenter.shared
    
    @Published var isAuthorized = false
    
    init() {
        
        Task {
            await updateAuthorizationStatus()
        }
    }
    
    func requestAuthorization() async {
        
        do {
           
            try await center.requestAuthorization(for: .individual)
            await updateAuthorizationStatus()
            print("Request sent succesfully!")
            

        } catch {
            print("Authorization error: \(error.localizedDescription)")
            
        }
    }
    
    func updateAuthorizationStatus() async {
        let status = center.authorizationStatus
        isAuthorized = (status == .approved )
        print("Screen Time authorization status: \(status.rawValue) ")
    }
}

struct CustomApp: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    var isRestricted: Bool = false
}

struct ItunesApp: Decodable {
    let trackId: Int
    let trackName: String
}

struct ItunesSearchResponse: Decodable {
    let results: [ItunesApp]
}

class CustomAppsViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [CustomApp] = []
    @Published var selectedApps: [CustomApp] = [] {
        didSet {
            saveSelectedApps()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadSelectedApps()

        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.searchResults = []
                } else {
                    self?.searchApps(query: text)
                }
            }
            .store(in: &cancellables)
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
                        CustomApp(id: String($0.trackId), name: $0.trackName)
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

    func saveSelectedApps() {
        if let encoded = try? JSONEncoder().encode(selectedApps) {
            UserDefaults.standard.set(encoded, forKey: "customApps")
        }
    }

    func loadSelectedApps() {
        if let savedData = UserDefaults.standard.data(forKey: "customApps"),
           let decoded = try? JSONDecoder().decode([CustomApp].self, from: savedData) {
            selectedApps = decoded
        }
    }

    func toggleRestriction(for app: CustomApp) {
        if let index = selectedApps.firstIndex(of: app) {
            selectedApps[index].isRestricted.toggle()
            selectedApps = selectedApps // triggers didSet
        }
    }

    func deleteApp(at offsets: IndexSet) {
        selectedApps.remove(atOffsets: offsets)
    }
}

struct SearchView: View {
    @EnvironmentObject var viewModel: CustomAppsViewModel
    @State private var recentlyAddedAppID: String? = nil

    var body: some View {
        VStack {
            TextField("Search for apps...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List(viewModel.searchResults) { app in
                HStack {
                    Text(app.name)
                    Spacer()
                    if recentlyAddedAppID == app.id {
                        Text("Added!")
                            .foregroundColor(.green)
                            .transition(.scale)
                            .animation(.easeInOut, value: recentlyAddedAppID)
                    } else {
                        Button("Add") {
                            if !viewModel.selectedApps.contains(app) {
                                withAnimation(.spring()) {
                                    viewModel.selectedApps.insert(app, at: 0)
                                    recentlyAddedAppID = app.id
                                }

                                // Reset "Added" label after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        recentlyAddedAppID = nil
                                    }
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .scaleEffect(recentlyAddedAppID == app.id ? 1.1 : 1.0)
                    }
                }
            }
        }
        .navigationTitle("Add Custom App")
    }
}
        
        
struct SettingsView: View {
    @StateObject private var viewModel = CustomAppsViewModel()
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @AppStorage("IsLoggedIn") var isLoggedIn: Bool = true
    @State private var isPressed = false
    
    
    private func handleLogout() {
        // Placeholder for logout info
        isLoggedIn = false
        print("Logged out")
    }
    
    
    
    var body: some View {
        NavigationView {
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
                        
                        NavigationLink(destination: Text("Link to Nikita's page")) {
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
                                
                    }
                
                    Section(header: Text("Limited-use Apps").font(.custom("futura", size: 25))
                        .foregroundColor(.white)) {
                        ForEach(viewModel.selectedApps) { app in
                            Toggle(app.name, isOn: Binding(
                                get: { app.isRestricted },
                                set: { newValue in
                                    viewModel.toggleRestriction(for: app)
                                }
                            ))
                        }
                        .onDelete(perform: viewModel.deleteApp)
                        
                        
                        NavigationLink(destination: SearchView().environmentObject(viewModel)) {
                            HStack {
                                Text("Add custom app")
                                Spacer()
                                Text("Details").foregroundColor(.gray)
                            }
                        }
                    }
                    .environmentObject(viewModel)
                   
                    
                    // else if isLogginIn{
                    //  LoginView(isLoggingIn:$isLoggingIn)
                    
                    
                    Section {
                        
                        Button(action: handleLogout) {
                            Text("Logout")
                                .background(Color.red)
                                .font(.custom("futura", size: 25))
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                                .scaleEffect(isPressed ? 1.25 : 1.0)
                                .animation(.easeIn, value: isPressed)
                            
                            // TO DO : Replace with real authentication sign-out
                        }
                        
                        .tint(.red)
                        .buttonStyle(.borderedProminent)
                        .frame(width: 200, height: 200)
                        .padding(.leading, 50)
                        .padding(.top, -60)
                        .simultaneousGesture(
                            DragGesture(minimumDistance:0)
                                .onChanged { _ in
                                    isPressed = true
                                }
                                .onEnded { _ in
                                    isPressed = false
                                }
                           
                            )
                        //.frame(maxWidth: .infinity)
                        
                    }
                    
                    .listRowBackground(Color(.cyan))
                    
                }
                        
                    }
            .scrollContentBackground(.hidden)
            .background(Color.cyan)
          
                    
                    
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
    

    
    #Preview {
        SettingsView()
    }

