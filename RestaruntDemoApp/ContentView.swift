//
//  ContentView.swift
//  RestaruntDemoApp
//
//  Created by Knoxpo MacBook Pro on 13/04/21.
//

import SwiftUI
import SDWebImageSwiftUI
import WebKit

struct ContentView: View {
    
    @ObservedObject var obs = observer()
    var body: some View {
        
        NavigationView{
            List(obs.datas){ i in
                
                Card(image: i.name, name: i.name, weburl: i.webUrl, rating: i.rating)
                
                
                
                
            }.navigationBarTitle("Near By Restro")
            
            
            
            
        }
        
        
        
    }
}

class observer: ObservableObject{
    
    @Published var datas = [datatype]()
    
    init() {
     let url1 = "https://developers.zomato.com/api/v2.1/geocode?lat=12.9716&lon=77.5946"
        
      let api = "7743aea88c2d4f753465c610ef1cf5a8"
        let url = URL(string: url1)
        var request = URLRequest(url: url!)
        request.addValue("application/json/json", forHTTPHeaderField: "Accept")
        
        request.addValue(api, forHTTPHeaderField: "user-key")
        request.httpMethod = "GET"
        let sess = URLSession(configuration: .default)
        sess.dataTask(with: request) {
            (data, _, _) in
            
            do{
               let fetch = try JSONDecoder()
                .decode(Type.self, from: data!)
                
               
                for i in
                    fetch
                    .nearby_restaurants{
     
                    
                    DispatchQueue.main.async {
                        self.datas.append(datatype(id: i.restaurant.id, name: i.restaurant.name, image: i.restaurant.thumb, rating: i.restaurant.user_rating.aggregate_rating, webUrl: i.restaurant.url))
                    }
                    
                  
                    
                }
                
            }
            catch {
                
                print(error .localizedDescription)
                
                
            }
            
            
            
        }
        .resume()
        
        
        
        
    }
    
    
    
}

//model
struct datatype: Identifiable {
    
    var id: String
    var name: String
    var image: String
    var rating: String
    var webUrl: String
   
}

struct Type: Decodable {
    var nearby_restaurants: [Type1]
}


struct Type1: Decodable {
    var restaurant : Type2
}

struct Type2: Decodable {
    
    var id : String
    var name : String
    var url : String
    var thumb : String
    var user_rating : Type3
}

struct Type3: Decodable {
    
    var aggregate_rating : String
    
}

struct Card : View {
    
   var image = ""
    var name = ""
    var weburl = ""
    var rating = ""
    
    var body: some View {
        
        NavigationLink(destination: register(url: weburl, name: name)) {
            
            HStack {
                
//                AnimatedImage(url: URL(string: image))
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .cornerRadius(4)
                VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.bold)
                Text(rating)
                    .fontWeight(.light)
                    
                    
                    
                }.padding(.vertical,10)
                
                
            }
           
            
        }
    
    }

}

//register
struct register : View {
    var url = ""
    var name = ""
    
    var body : some View {
        
        Webview(url: url).navigationBarTitle(name)
    }
}

//webview

struct Webview: UIViewRepresentable {
    var url = ""
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let web = WKWebView()
        web.load(URLRequest(url: URL(string: url)!))
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Webview>) {
        
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
