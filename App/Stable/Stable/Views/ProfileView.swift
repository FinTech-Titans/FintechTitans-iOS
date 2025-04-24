//
//  ProfileView.swift
//  Stable
//
//  Created by Lee Burrows on 24/04/2025.
//

import SwiftUI

// MARK: - ProfileView
struct ProfileView: View {
    @State private var profile: Profile?
    @State private var isLoading = false
    @State private var errorMessage: String?
    private let networkClient = NetworkingClient()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileHeader
                
                if isLoading {
                    loadingIndicator
                } else if let error = errorMessage {
                    errorMessage(message: error)
                } else if let profile = profile {
                    profileDetails(profile: profile)
                } else {
                    emptyState
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
        .navigationTitle("Profile")
        .task {
            await loadProfile()
        }
    }
    
    // MARK: - UI Components
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(profile?.displayName ?? "Welcome")
                .font(.title.bold())
                .foregroundColor(.primary)
        }
        .padding(.top, 20)
    }
    
    private var loadingIndicator: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading profile...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.fill.questionmark")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.secondary)
            
            Text("No profile information available")
                .font(.headline)
            
            Button {
                Task {
                    await loadProfile()
                }
            } label: {
                Text("Refresh")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(.vertical, 30)
    }
    
    private func errorMessage(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            
            Text("Error Loading Profile")
                .font(.headline)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button {
                Task {
                    await loadProfile()
                }
            } label: {
                Text("Try Again")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
    
    private func profileDetails(profile: Profile) -> some View {
        VStack(spacing: 20) {
            infoSection(title: "Account Details") {
                infoRow(icon: "envelope", title: "Email", value: profile.email)
                Divider()
            }
            
            infoSection(title: "Technical Information") {
                infoRow(icon: "person.text.rectangle", title: "Account ID", value: profile.id)
            }
            
            Button {
                Task {
                    await loadProfile()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh Profile")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.top, 10)
        }
    }
    
    private func infoSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            
            VStack {
                content()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
    }
    
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Data Handling
    
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil

        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        do {
            self.profile = try await networkClient.getProfile()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
            }
        }
        

    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ProfileView()
    }
}
