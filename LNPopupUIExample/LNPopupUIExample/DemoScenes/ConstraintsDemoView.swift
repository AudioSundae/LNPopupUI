//
//  SafeAreaDemoView.swift
//  LNPopupUIExample
//
//  Created by Leo Natan (Wix) on 9/5/20.
//

import SwiftUI
import LNPopupUI
import LoremIpsum

extension View {
	@ViewBuilder
	func ifLet<V, Transform: View>(
		_ value: V?,
		transform: (Self, V) -> Transform
	) -> some View {
		if let value = value {
			transform(self, value)
		} else {
			self
		}
	}
}

struct SafeAreaDemoView : View {
	let includeLink: Bool
	let offset: Bool
	let onDismiss: (() -> Void)?
	
	init(includeLink: Bool = false, offset: Bool = false, onDismiss: (() -> Void)? = nil) {
		self.includeLink = includeLink
		self.offset = offset
		self.onDismiss = onDismiss
	}
	
	var body: some View {
		ZStack(alignment: .trailing) {
			VStack {
				Text("Top").offset(x: offset ? 40.0 : 0.0)
				Spacer()
				Text("Center")
				Spacer()
				Text("Bottom")
			}.frame(minWidth: 0,
					maxWidth: .infinity,
					minHeight: 0,
					maxHeight: .infinity,
					alignment: .top)
			if includeLink {
				NavigationLink("Next ▸", destination: SafeAreaDemoView(includeLink: includeLink, onDismiss: onDismiss).navigationTitle("LNPopupUI"))
					.padding()
			}
		}
		.padding(4)
		.font(.system(.headline))
		.ifLet(onDismiss) { view, onDismiss in
			view.navigationBarItems(trailing: Button("Gallery") {
				onDismiss()
			})
		}
	}
}

//return view

extension View {
	func popupDemo(isBarPresented: Binding<Bool>) -> some View {
		return self.popup(isBarPresented: isBarPresented, onOpen: { print("Opened") }, onClose: { print("Closed") }) {
			SafeAreaDemoView(offset: true)
			.popupTitle(LoremIpsum.title, subtitle: LoremIpsum.sentence)
			.popupImage(Image("genre\(Int.random(in: 1..<31))"))
			.popupBarItems({
				HStack(spacing: 20) {
					Button(action: {
						print("Play")
					}) {
						Image(systemName: "play.fill")
					}
					
					Button(action: {
						print("Next")
					}) {
						Image(systemName: "forward.fill")
					}
				}
				.font(.system(size: 20))
			})
		}
		.popupCloseButtonStyle(.chevron)
//		.popupInteractionStyle(.drag)
	}
}
