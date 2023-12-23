import Foundation


// PRACTICA 1- SWIFT

/*
 Descripción: Desarrolla un sistema para gestionar reservas de hotel para Goku y sus amigos.
 Requisitos:
 1. Modela las estructuras: Client (cliente), Reservation (reserva) y ReservationError
 (errores de la reserva).
 1. Client: nombre, edad, altura (cm).
 2. Reservation: ID único, nombre del hotel, lista de clientes, duración (días), precio,
 opción de desayuno (true/false).
 
 3. ReservationError. Enumerado que implemente Error con tres errores (cases)
 posibles: se encontró reserva con el mismo ID, se encontró reserva para un cliente y
 no se encontró reserva.
 2. Gestiona las reservas con la clase HotelReservationManager.
 1. Crea un listado para almacenar reservas.
 2. Crea método para añadir una reserva. Añade una reserva dado estos parámetros: lista
 de clientes, duración, opción de desayuno. Asigna un ID único (puedes usar un
 contador por ejemplo), calcula el precio y agrega el nombre del hotel.
 1. Verifica que la reserva sea única por ID y cliente antes de agregarla al listado. En
 caso de ser incorrecta, lanza o devuelve el error ReservationError
 correspondiente. Es decir, no puede haber otra reserva con el mismo identificador
 ni puede haber una reserva en la que coincida algún cliente con una reserva previa.
 2. El cálculo del precio es así: número de clientes * precio base por
 cliente (20 euros quizá) * días en el hotel * 1,25 si toman
 desayuno o 1 si no toman desayuno.
 Ejemplo: 3 (clientes) * 20 euros (precio base) * 2 (días en
 hotel) * 1,25 (porque toman desayuno) = 3*20*2*1.25 = 150
 3. Añade la reserva al listado de reservas.
 4. Devuelve la reserva.
 3. Crea un método para cancelar una reserva. Cancela la reserva dado su ID, lanzando
 un ReservationError si esta no existe. Para cancelar una reserva simplemente
 elimínala del listado de reservas dado su identificador.
 4. Crea un método (o propiedad de solo lectura) para obtener un listado de todas las
 reservas actuales.
 Para probar tú mismo tu propio código crea las siguientes funciones y ejecútalas en el
 Playground:
 1. testAddReservation: verifica errores al añadir reservas duplicadas (por ID o si otro
 cliente ya está en alguna otra reserva) y que nuevas reservas sean añadidas
 correctamente.
 2. testCancelReservation: verifica que las reservas se cancelen correctamente
 (borrándose del listado) y que cancelar una reserva no existente resulte en un error.
 3. testReservationPrice: asegura que el sistema calcula los precios de forma
 consistente. Por ejemplo: si hago dos reservas con los mismos parámetros excepto el
 nombre de los clientes, me deberían dar el mismo precio.
 Consejo para los tests: usa la función assert para hacer comprobaciones de si algo es
 verdadero, ejemplo: assert(hotelReservationManager.reservations.count == 1),
 si el número de reservas es 1 entonces continúa, sino, el programa falla alertándote del error.
 Puedes usar además assertionFailure("no debe ocurrir") para lanzar un error cuando
 algo no deba ocurrir.

*/


struct Client: Equatable, Hashable {
    
    let name: String
    let age: Int
   let height: Double
    
    init(name: String, age: Int, height: Double) {
        self.name = name
        self.age = age
        self.height = height
    }
    }
    


struct Reservation {
    
    let uniqueID :UUID
    let hotelName: String
    let Guests: [Client]
    let durationDays: Int
    let price: Double
    let IncludeBreakfast: Bool
    
    init(uniqueID: UUID, hotelName: String, Guests: [Client], 
         durationDays: Int, price: Double, IncludeBreakfast: Bool) {
        self.uniqueID = uniqueID
        self.hotelName = hotelName
        self.Guests = Guests
        self.durationDays = durationDays
        self.price = price
        self.IncludeBreakfast = IncludeBreakfast
    }
    
    
}
    
enum ReservationError: Error {
    case SameIdError
    case ReservationExistsError
    case ReservationNotFound
    
}


class ReservationManager {
    var clients: [Client] = []
    var reservations: [Reservation] = []
    
    
    func addReservation(clientList: [Client], duration: Int, includeBreakfast: Bool) throws {
        
        let newReservationID = UUID().uuidString
        
        // Calculo el precio
        var pricePerClient = 20.0
        var priceMultiplier = includeBreakfast ? 1.25 : 1.0
        var totalPrice = Double(clientList.count) * pricePerClient * Double(duration) * priceMultiplier
        
        // Chequeo que no existe otra reservacion con el mismo ID
        if reservations.contains(where: { $0.uniqueID.uuidString == newReservationID }) {
            throw ReservationError.ReservationExistsError
        }
        
        // Checar por reservaciones existentes
        if reservations.contains(where: { reservation in
            reservation.Guests.contains(where: { element in
                clientList.contains { client in
                    client == element
                }
            })
        }) {
            throw ReservationError.ReservationExistsError
        }
        // Crea una nueva reservacion
        let newReservation = Reservation(
            uniqueID: UUID(uuidString: newReservationID)!,
            hotelName: "El Gran Namekusei Resort",
            Guests: clientList,
            durationDays: duration,
            price: totalPrice,
            IncludeBreakfast: includeBreakfast)
        
        // Agregar la reservacion
        reservations.append(newReservation)
        
        // agregar el cliente a la lista de clientes
        let ClientsSet = Set(clients)
        for client in clientList {
            if !ClientsSet.contains(client) {
                clients.append(client)
            }
        }
        
    }
    
    
    
    // Metodo para cancelar una reservacion
    
    
    func cancelReservation(reservationID: UUID) throws {
            guard let index = reservations.firstIndex(where: {
                $0.uniqueID == reservationID }) else {
                throw ReservationError.ReservationNotFound
            }

            reservations.remove(at: index)
        }
    
    
    
    // Metodo que me devuelva lista de reservacion
    
    func ListOfReservations() -> [Reservation] {
            return reservations
        }
    
    }

    









//TESTS DE RESERVACIONES
    
    

// Test 1: Añadir una reserva correctamente

// Test 1: Añadir una reserva válida

func testAddReservation() {
    let reservationManager = ReservationManager()
    
    let client1 = Client(name: "Vegeta", age: 30, height: 175.0)
    let client2 = Client(name: "Bulma", age: 28, height: 162.5)
    
    
    do {
        try reservationManager.addReservation(clientList: [client1, client2],
                                              duration: 3, includeBreakfast: true)
        print("Test 1: Reserva añadida correctamente.")
        print(reservationManager.ListOfReservations())
    } catch {
        print("Error en Test 1: \(error)")
    }
    
    
    // Test 2: Añadir reserva duplicada
    
    
    let newClient1 = Client(name: "Vegeta", age: 30, height: 175.0)
    let newClient2 = Client(name: "Bulma", age: 28, height: 162.5)
    
    
    do {
        try reservationManager.addReservation(clientList: [client1, client2],
                                              duration: 3, includeBreakfast: true)
        print("Error en Test 2: Se permitió la reserva duplicada.")
    } catch ReservationError.ReservationExistsError {
        print("Test 2: Error capturado correctamente (Reserva duplicada por ID).")
    } catch {
        print("Error inesperado en Test 2")
    }
}
    
    




//TESTS DE CANCELACIONES



func testCancelReservation() {
    let reservationManager = ReservationManager()
    
    
    let client1 = Client(name: "Vegeta", age: 30, height: 175.0)
    let client2 = Client(name: "Bulma", age: 28, height: 162.5)
    
    do {
        try reservationManager.addReservation(clientList: [client1, client2],
                                              duration: 3, includeBreakfast: true)
    } catch {
        print("Error al crear reserva")
    }
    
    
    do {
        let reservationsBeforeCancel = reservationManager.ListOfReservations().count
        try reservationManager.cancelReservation(reservationID: reservationManager.reservations[0].uniqueID)
        let reservationsCanceled = reservationManager.ListOfReservations().count
        
        assert(reservationsBeforeCancel == reservationsCanceled + 1, "Test 1: Error al cancelar reserva.")
        print("Test 1: Reserva cancelada")
    } catch {
        print("Error en Test 1")
    }
}





// TEST DE CALCULO DE PRECIOS



func testReservationPrice() {
        let reservationManager = ReservationManager()
        
    
        let client1 = Client(name: "Gohan", age: 16, height: 1.75)
        let client2 = Client(name: "Pikoro", age: 42, height: 1.82)
        
        // Test 1: Crear dos reservas con los mismos parámetros excepto el nombre de los clientes
        do {
            try reservationManager.addReservation(clientList: [client1, client2], duration: 3, includeBreakfast: true)
            let reservation1 = reservationManager.ListOfReservations()[0]
            
            try reservationManager.addReservation(clientList: [Client(name: "Goku", age: 35, height: 160.0), Client(name: "Milk", age: 33, height: 1.50)], duration: 3, includeBreakfast: true)
            let reservation2 = reservationManager.ListOfReservations()[1]
            
            assert(reservation1.price == reservation2.price, "Test 1: Error en el cálculo del precio.")
            print("Test 1: Cálculo del precio correcto.")
        } catch {
            print("Error en Test 1")
        }
    }


// Ejecutar las pruebas
testAddReservation()
testCancelReservation()
testReservationPrice()
