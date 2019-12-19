import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    ///Basic routing
    router.get("movies") { req in
        return "Movies"
    }
    
    router.get("movies/action") { req in
           return "Action Movies"
    }
    
    
    ///Grouping
    let moviesGroup = router.grouped("api/movies/")
    moviesGroup.get("comedy") { req in
        return "comedy Movie"
    }
    moviesGroup.get("romance") { req in
        return "romantic movies"
    }
    
    
    ////Parameters
    // movies/comedy
    router.get("movies", String.parameter) {req -> String in
        let genre = try req.parameters.next(String.self)
        return "Genre is \(genre)"
    }
    // movies/comedy/year/1990
    router.get("movies", String.parameter,"year",Int.parameter) {req -> String in
        let genre = try req.parameters.next(String.self)
        let year = try req.parameters.next(Int.self)
        return "Genre is \(genre) and year is \(year)"
    }
    
    
    ///Query String
    // movies?search=batman&page=10&sort=desc
    router.get("movies") { req -> String in
        let search = try req.query.get(String.self, at: "search")
        let page = try req.query.get(Int.self, at: "page")
        let sort = try req.query.get(String.self, at: "sort")
        return "\(search) \(page) \(sort)"
    }
    
    
    ///// Returning JSON
    final class Dish: Content {
        var id: Int?
        var title: String
        var price: Double
        var description: String
        
        init(title: String, description: String, price: Double){
            self.title = title
            self.price = price
            self.description = description
        }
    }
    
    router.get("dish") {req -> Dish in
        let dish = Dish(title: "A", description: "B", price: 3.5)
        return dish
    }
    
    router.get("dishes") {req -> [Dish] in
           let dish1 = Dish(title: "A1", description: "B1", price: 3.5)
           let dish2 = Dish(title: "A2", description: "B2", price: 4.5)
           return [dish1,dish2]
    }
    
    
    ///// Post Json
    router.post(Dish.self, at: "api/dish") { req, data -> Future<Dish> in
        return Future.map(on: req) { () -> Dish in
            data.id = 100
            return data
        }
    }
    
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
