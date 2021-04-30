import SwiftUI

struct MyView: View {
    @ObservedObject var viewModel = MyViewModel()

    init() {
        viewModel.updateItems()
    }
    
    var body: some View {
        List(viewModel.items, id: \.self) { item in
            Text(item)
        }
        .padding(10)
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
