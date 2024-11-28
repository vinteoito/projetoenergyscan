import SwiftUI

@main
struct EnergyMonitorApp: App {
   @State private var usuario: Usuario? // Para armazenar o usuário cadastrado
   
   var body: some Scene {
       WindowGroup {
           if usuario == nil {
               CadastroUsuarioView(usuario: $usuario) // Se o usuário não estiver cadastrado, mostrar a tela de cadastro
           } else {
               HomeView(usuario: usuario!) // Se o usuário estiver cadastrado, exibir a tela principal
           }
       }
   }
}
