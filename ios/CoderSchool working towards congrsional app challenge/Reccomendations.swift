import SwiftUI

struct HomeView: View {
    let under30Options = ["Go for a walk or jog", "Draw something", "Read a short story", "Do a quick workout", "Eat a snack", "Do some yoga", "Journal about your day", "Write a quick poem","Listen to music or a podcast", "Learn a simple magic trick", "Try a brain teaser or puzzle", "Water your plants/gardening", "Try some quick origami", "Write a gratitude list", "Learn a few jokes", "Write letters to your future self", "Make a paper airplane", "Make a smoothie", "Step outside and watch clouds", "Play with your pet", "Play a short card game", "Try calligraphy"]
    let under1HourOptions = ["Bake cookies", "Rearrange your desk setup", "Clean your room", "Do a puzzle", "Learn a new song on your instrument", "Tidy or organize a space", "Expirement with a new recipe or dish", "Try a DIY craft","Read a chapter of a book","Build something with legos","Do a mini science expirement at home", "Practice a sport/skill", "Do karaoke with friends or family", "Try out a new hairstyle", "Make a vision or mood board", "Build a blanket fort", "Make a nature collage", "Decorate a water bottle or notebook"]
    let over1HourOptions = ["Start a new book", "Learn a language", "Do a craft project", "Play a game", "Learn a new instrument", "Crochet, sew, or knit something", "Volunteer for a cause you like", "Go on a hike", "Go for a long bike ride", "Paint a landscape or portrait", "Learn choreography for a dance", "Try cooking a full meal from scratch", "Work on a scrapbook or photo album", "Create a short film/skit", "Build a birdhouse", "Have a backyard picnic", "Explore a new park", "Host a mini talent show", "Start a passion project"]
    
    @State private var under30: [String] = []
    @State private var under1Hour: [String] = []
    @State private var over1Hour: [String] = []
    
    @State private var under30Pool: [String] = []
    @State private var under1HourPool: [String] = []
    @State private var over1HourPool: [String] = []
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Recommendations")
                    .foregroundColor(.white)
                    .font(.custom("futura", size: 35))
                    .padding(.leading, 20)
                
                Spacer()
                
                Button(action: {
                    refreshRecommendations()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.trailing, 40)
                }
            }
            .padding(.top, 50)
            
            reccomendationBox(title: "Under 30 minutes", items: under30)
            reccomendationBox(title: "Under 1 hour", items: under1Hour)
            reccomendationBox(title: "Over 1 hour", items: over1Hour)
            
            Spacer()
        }
        .background(Color.cyan.ignoresSafeArea())
        .task {
            setupPools()
            refreshRecommendations()
        }
    }
    
    func reccomendationBox(title: String, items: [String]) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.custom("futura", size: 23))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                        Text(item)
                    }
                }
                .foregroundColor(.black)
                .font(.custom("futura", size: 16))
                
            }
            .padding()
            .frame(width: 370, alignment: .leading)
            .background(Color.white)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func setupPools() {
        under30Pool = under30Options.shuffled()
        under1HourPool = under1HourOptions.shuffled()
        over1HourPool = over1HourOptions.shuffled()
    }
    
    private func refreshRecommendations() {
        under30 = draw( 4, from: &under30Pool, fullPool: under30Options)
        under1Hour = draw(4, from: &under1HourPool, fullPool: under1HourOptions)
        over1Hour = draw(4, from: &over1HourPool, fullPool: over1HourOptions)
    }
    
    private func draw(_ n: Int, from pool: inout [String], fullPool: [String]) -> [String] {
        var result: [String] = []
        for _ in 0..<n {
            if pool.isEmpty { pool = fullPool.shuffled() }
            result.append(pool.removeFirst())
    }
        return result
    }
 
}

    #Preview {
        HomeView()
    }

