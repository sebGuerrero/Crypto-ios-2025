import SwiftUI

struct MainView: View {
    
    @State var showModal: Bool = false
    
    var body: some View {
        Button {
            showModal.toggle()
        } label: {
            Text("Show Modal")
        }
        .sheet(isPresented: $showModal) {
            ModalView()
        }
    }
}



struct ModalView: View {
    var body: some View {
        Text("Modal View")
    }
}


#Preview {
    MainView()
}
