//
//  View.swift
//  communitycooking
//
//  Created by FMA2 on 03.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func flippedUpsideDown() -> some View{
      self.modifier(FlippedUpsideDown())
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func KeyboardAwarePadding(offsetY: CGFloat = 0) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier(offsetY: offsetY))
    }
    
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    @inlinable public func onViewResult(perform action: @escaping ([String: Any]) -> Void) -> some View {
        return self
    }
}
