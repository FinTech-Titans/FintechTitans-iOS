import SwiftUI

// Import StorySubTopicItem
struct StoryItem: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let image: String // System name or asset name
}

struct StorySubTopicItem: Identifiable {
    let id = UUID()
    let title: String
    let items: [StoryItem]
}

// MARK: - ViewModel
class StoryViewModel: ObservableObject {
    @Published var subTopic: StorySubTopicItem
    @Published var currentIndex = 0
    
    init(subTopic: StorySubTopicItem) {
        self.subTopic = subTopic
    }
}

// MARK: - Story View
struct StoryView: View {
    @StateObject private var viewModel: StoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset: CGFloat = 0
    
    init(subTopic: StorySubTopicItem) {
        _viewModel = StateObject(wrappedValue: StoryViewModel(subTopic: subTopic))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text(viewModel.subTopic.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Empty view to balance the layout
                    Image(systemName: "xmark")
                        .foregroundColor(.clear)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                }
                
                // Progress bar
                HStack(spacing: 4) {
                    ForEach(0..<viewModel.subTopic.items.count, id: \.self) { index in
                        Rectangle()
                            .fill(index <= viewModel.currentIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(height: 2)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Main content
                if viewModel.currentIndex < viewModel.subTopic.items.count {
                    let item = viewModel.subTopic.items[viewModel.currentIndex]
                    
                    VStack(spacing: 30) {
                        Image(systemName: item.image)
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        Text(item.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(item.content)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 50)
                }
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if viewModel.currentIndex > 0 {
                        Button(action: {
                            withAnimation {
                                viewModel.currentIndex -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                        }
                    } else {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    if viewModel.currentIndex < viewModel.subTopic.items.count - 1 {
                        Button(action: {
                            withAnimation {
                                viewModel.currentIndex += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                        }
                    } else {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Finish")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold && viewModel.currentIndex > 0 {
                        withAnimation {
                            viewModel.currentIndex -= 1
                        }
                    } else if value.translation.width < -threshold && viewModel.currentIndex < viewModel.subTopic.items.count - 1 {
                        withAnimation {
                            viewModel.currentIndex += 1
                        }
                    }
                }
        )
    }
} 
