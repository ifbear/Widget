//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by dexiong on 2023/5/4.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
