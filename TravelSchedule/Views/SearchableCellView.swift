//
//  SearchableCellView.swift
//  TravelSchedule
//
//  Created by Evgeniy Kostyaev on 11.02.2026.
//

import SwiftUI

private enum Layout {
    static let textFontSize: CGFloat = 17
    static let rowChevronSize: CGFloat = 20
    static let buttonHeight: CGFloat = 60.0
    static let listRowInsetTop: CGFloat = 0
    static let horizontalPadding: CGFloat = 16
    static let listRowInsetBottom: CGFloat = 0
}

struct SearchableCellView: View {
    var item: String
    var onSelect: (String) -> Void
    
    var body: some View {
        Button {
            onSelect(item)
        } label: {
            HStack {
                Text(item)
                    .font(.system(size: Layout.textFontSize, weight: .regular))
                    .foregroundStyle(Color.customBlack)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: Layout.rowChevronSize, weight: .semibold))
                    .foregroundStyle(Color.customBlack)
                    
            }
        }
        .frame(height: Layout.buttonHeight)
        .listRowInsets(
            EdgeInsets(
                top: Layout.listRowInsetTop,
                leading: Layout.horizontalPadding,
                bottom: Layout.listRowInsetBottom,
                trailing: Layout.horizontalPadding
            )
        )
    }
}

#Preview {
    SearchableCellView(item: "Москва", onSelect: { _ in
        
    })
}
