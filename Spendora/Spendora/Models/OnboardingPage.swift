/**
 * Main/Core Functions & Purpose:
 * OnboardingPage model defining metadata, icon, title, description, accent color, and optional image asset name for welcome slides.
 */

import SwiftUI

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
    var customImageName: String? = nil
}
