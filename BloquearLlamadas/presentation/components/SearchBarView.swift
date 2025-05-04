//
//  SearchBarView.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//
import SwiftUI

struct SearchBarView: View {
    
    @Bindable var vm: ContentViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Filtrar por nombre de contacto", text: $vm.nameFilter, axis: .vertical)
                .textFieldStyle(.plain)
            
            if !vm.nameFilter.isEmpty {
                /// Botón para borrar el texto
                Button(action: { vm.clearFilter() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
        .padding(.vertical, 16)
    }
}
