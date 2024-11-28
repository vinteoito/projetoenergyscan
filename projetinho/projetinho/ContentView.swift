import SwiftUI

struct HomeView: View {
    var usuario: Usuario // Passamos o usuário para personalizar a tela principal
    
    @State private var eletrodomesticos: [Eletrodomestico] = []
    @State private var totalGasto: Double = 0.0

    var body: some View {
        NavigationView {
            VStack {
                Text("Bem-vindo, \(usuario.nome)!")
                    .font(.title)
                    .padding()

                List {
                    ForEach(eletrodomesticos, id: \.id) { eletro in
                        Text("\(eletro.nome): \(eletro.potencia)W por \(eletro.horasUsadasPorDia) horas/dia")
                    }
                }
               

                Text("Custo total estimado: R$ \(totalGasto, specifier: "%.2f")")
                    .font(.headline)
                    .padding()

                NavigationLink(destination: CadastroView(eletrodomesticos: $eletrodomesticos, totalGasto: $totalGasto)) {
                    Text("Cadastrar Novo Eletrodoméstico")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

            }
            .navigationTitle("Monitor de Energia")
            .onAppear(perform: calculateTotalCost)
            .navigationBarItems(leading: Button("Voltar") {
                // Lógica para voltar, no caso de uma navegação de volta manual
            })
        }
    }

    private func calculateTotalCost() {
        totalGasto = eletrodomesticos.reduce(0) { total, eletro in
            total + (eletro.potencia * eletro.horasUsadasPorDia * 30 / 1000 * 0.5) // R$
        }
    }
}

struct CadastroUsuarioView: View {
    @Binding var usuario: Usuario? // Binding para armazenar o usuário após o cadastro
    
    @State private var nome: String = ""
    @State private var email: String = ""
    @State private var senha: String = ""
    
    @State private var isError: Bool = false
    @Environment(\.presentationMode) var presentationMode // Para permitir voltar manualmente
    
    var body: some View {
        VStack {
            Text("Cadastro de Usuário")
                .font(.largeTitle)
                .padding()

            TextField("Nome", text: $nome)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("E-mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Senha", text: $senha)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Cadastrar") {
                cadastrarUsuario()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            if isError {
                Text("Preencha todos os campos corretamente.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .navigationBarItems(leading: Button("Voltar") {
            presentationMode.wrappedValue.dismiss() // Volta para a tela anterior
        })
    }

    private func cadastrarUsuario() {
        // Validação simples dos campos
        guard !nome.isEmpty, !email.isEmpty, !senha.isEmpty else {
            isError = true
            return
        }
        
        // Simulando o cadastro do usuário
        usuario = Usuario(nome: nome, email: email, senha: senha)
    }
}

struct Usuario {
    var nome: String
    var email: String
    var senha: String
}

struct CadastroView: View {
    @Binding var eletrodomesticos: [Eletrodomestico]
    @Binding var totalGasto: Double

    @State private var nome: String = ""
    @State private var potencia: String = ""
    @State private var horasUsadasPorDia: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Cadastrar Eletrodoméstico")
                .font(.largeTitle)
                .padding()

            TextField("Nome do Eletrodoméstico", text: $nome)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Potência (W)", text: $potencia)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()

            TextField("Horas por dia", text: $horasUsadasPorDia)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()

            Button("Salvar") {
                addEletrodomestico()
                presentationMode.wrappedValue.dismiss() // Volta para a tela anterior
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationBarItems(leading: Button("Voltar") {
            presentationMode.wrappedValue.dismiss() // Volta para a tela anterior
        })
    }

    private func addEletrodomestico() {
        guard let potenciaValue = Double(potencia), potenciaValue > 0,
              let horasValue = Double(horasUsadasPorDia), horasValue >= 0 else {
            return
        }

        let novoEletro = Eletrodomestico(nome: nome, potencia: potenciaValue, horasUsadasPorDia: horasValue)
        eletrodomesticos.append(novoEletro)

        calculateTotalCost()
    }

    private func calculateTotalCost() {
        totalGasto = eletrodomesticos.reduce(0) { total, eletro in
            total + (eletro.potencia * eletro.horasUsadasPorDia * 30 / 1000 * 0.5) // R$
        }
    }
}

struct Eletrodomestico: Identifiable {
    let id = UUID()
    var nome: String
    var potencia: Double
    var horasUsadasPorDia: Double
}
