import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MathBeautyView()
                .tabItem {
                    Label("Math", systemImage: "function")
                }

            MineView()
                .tabItem {
                    Label("Mine", systemImage: "person")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.tint)

            Text("Hello, Codex")
                .font(.largeTitle.bold())

            Text("hellocodex is running.")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct MathBeautyView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSinceReferenceDate

                GeometryReader { geometry in
                    ZStack {
                        FormulaBackdrop()
                            .padding(.horizontal, 24)
                            .padding(.top, 78)

                        FunctionButterflyCanvas(time: elapsed)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 130)
                            .padding(.bottom, 150)

                    }
                }
            }
        }
        .toolbarBackground(.black, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
    }

}

struct FormulaBackdrop: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            formulaLine("x(u,v) = e^(2au) / 2C [e^(-Cu) cos((2a-C)v) / (2aA-AC) - 4e^Cu cos((2a+C)v) / (2a+C)]", color: .cyan)
            formulaLine("y(u,v) = e^(2au) / 2C [e^(-Cu) sin((2a-C)v) / (2aA-AC) + 4e^Cu sin((2a+C)v) / (2a+C)]", color: .green)
            formulaLine("z(u,v) = e^(2au) / 2C · cos(2av) / a", color: .orange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(0.82)
    }

    private func formulaLine(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .serif))
            .foregroundStyle(color)
            .lineLimit(2)
            .minimumScaleFactor(0.72)
            .shadow(color: color.opacity(0.8), radius: 6)
    }
}

struct FunctionButterflyCanvas: View {
    let time: TimeInterval

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width * 0.5, y: size.height * 0.48)
            let scale = min(size.width, size.height) * 0.18
            let rotation = CGFloat(sin(time * 0.18) * 0.18)

//            drawAxes(in: &context, size: size, center: center, rotation: rotation)
            drawParticleField(in: &context, size: size, center: center, scale: scale, rotation: rotation)
            drawButterflyCurves(in: &context, size: size, center: center, scale: scale, rotation: rotation)
        }
    }

    private func drawAxes(in context: inout GraphicsContext, size: CGSize, center: CGPoint, rotation: CGFloat) {
        let axisColor = Color.white.opacity(0.34)
        var horizontal = Path()
        let h1 = rotate(CGPoint(x: -size.width * 0.48, y: 0), by: rotation * 0.5)
        let h2 = rotate(CGPoint(x: size.width * 0.48, y: 0), by: rotation * 0.5)
        horizontal.move(to: CGPoint(x: center.x + h1.x, y: center.y + h1.y))
        horizontal.addLine(to: CGPoint(x: center.x + h2.x, y: center.y + h2.y))
        context.stroke(horizontal, with: .color(axisColor), lineWidth: 1.2)

        var vertical = Path()
        let v1 = rotate(CGPoint(x: 0, y: -size.height * 0.42), by: rotation * 0.5)
        let v2 = rotate(CGPoint(x: 0, y: size.height * 0.42), by: rotation * 0.5)
        vertical.move(to: CGPoint(x: center.x + v1.x, y: center.y + v1.y))
        vertical.addLine(to: CGPoint(x: center.x + v2.x, y: center.y + v2.y))
        context.stroke(vertical, with: .color(axisColor), lineWidth: 1.2)

        drawArrow(at: CGPoint(x: center.x + h1.x, y: center.y + h1.y), angle: .pi + rotation * 0.5, in: &context)
        drawArrow(at: CGPoint(x: center.x + v2.x, y: center.y + v2.y), angle: .pi / 2 + rotation * 0.5, in: &context)

        for tick in -5...5 where tick != 0 {
            let point = rotate(CGPoint(x: CGFloat(tick) * size.width * 0.08, y: 0), by: rotation * 0.5)
            let normal = rotate(CGPoint(x: 0, y: 5), by: rotation * 0.5)
            var tickPath = Path()
            tickPath.move(to: CGPoint(x: center.x + point.x - normal.x, y: center.y + point.y - normal.y))
            tickPath.addLine(to: CGPoint(x: center.x + point.x + normal.x, y: center.y + point.y + normal.y))
            context.stroke(tickPath, with: .color(axisColor), lineWidth: 1)
        }
    }

    private func drawParticleField(in context: inout GraphicsContext, size: CGSize, center: CGPoint, scale: CGFloat, rotation: CGFloat) {
        for index in 0..<620 {
            let seed = Double(index)
            let angle = seed * 2.399963 + time * 0.18
            let wave = sin(time * 0.95 + seed * 0.071)
            let radius = scale * (0.18 + CGFloat(seed.truncatingRemainder(dividingBy: 130)) / 34.0) * CGFloat(0.72 + wave * 0.08)
            let petal = CGFloat(sin(angle * 2.0 + time * 0.55)) * scale * 0.34
            let raw = CGPoint(
                x: cos(angle) * Double(radius + petal),
                y: sin(angle * 1.38) * Double(radius * 0.72) + sin(angle * 4.0) * Double(scale * 0.15)
            )
            let point = rotate(raw, by: rotation)
            let opacity = 0.36 + 0.42 * abs(sin(seed * 0.11 + time * 1.8))
            let color = particleColor(index: index, opacity: opacity)
            let dotSize = CGFloat(1.2 + abs(sin(seed * 0.41)) * 2.4)
            let rect = CGRect(
                x: center.x + point.x - dotSize / 2,
                y: center.y + point.y - dotSize / 2,
                width: dotSize,
                height: dotSize
            )
            context.fill(Path(ellipseIn: rect), with: .color(color))
        }
    }

    private func drawButterflyCurves(in context: inout GraphicsContext, size: CGSize, center: CGPoint, scale: CGFloat, rotation: CGFloat) {
        for layer in 0..<7 {
            var path = Path()
            let offset = Double(layer) * .pi / 7 + time * 0.52
            let amplitude = 0.78 + CGFloat(layer) * 0.045
            let color = curveColor(layer: layer)

            for step in 0...520 {
                let t = Double(step) / 520.0 * .pi * 2.0
                let r = exp(cos(t + offset) * 0.42) - 1.75 * cos(4.0 * (t + offset)) + pow(sin((t + offset) / 12.0), 5.0)
                let wing = CGFloat(r) * scale * amplitude
                let twist = CGFloat(sin(time * 0.8 + Double(layer))) * 0.12
                let x = CGFloat(sin(t)) * wing
                let y = -CGFloat(cos(t + twist)) * wing * 0.62
                let point = rotate(CGPoint(x: x, y: y), by: rotation)
                let screen = CGPoint(x: center.x + point.x, y: center.y + point.y)

                if step == 0 {
                    path.move(to: screen)
                } else {
                    path.addLine(to: screen)
                }
            }

            context.stroke(path, with: .color(color.opacity(0.78)), lineWidth: 1.7)
            context.stroke(path, with: .color(color.opacity(0.22)), lineWidth: 6)
        }

        context.fill(
            Path(ellipseIn: CGRect(x: center.x - 16, y: center.y - 16, width: 32, height: 32)),
            with: .color(.black)
        )
        context.stroke(
            Path(ellipseIn: CGRect(x: center.x - 16, y: center.y - 16, width: 32, height: 32)),
            with: .color(.pink.opacity(0.8)),
            lineWidth: 1.4
        )
    }

    private func drawArrow(at point: CGPoint, angle: CGFloat, in context: inout GraphicsContext) {
        let length: CGFloat = 34
        let spread: CGFloat = 0.58
        var path = Path()
        path.move(to: point)
        path.addLine(to: CGPoint(x: point.x + cos(angle - spread) * length, y: point.y + sin(angle - spread) * length))
        path.addLine(to: CGPoint(x: point.x + cos(angle + spread) * length, y: point.y + sin(angle + spread) * length))
        path.closeSubpath()
        context.fill(path, with: .color(.white.opacity(0.92)))
    }

    private func rotate(_ point: CGPoint, by angle: CGFloat) -> CGPoint {
        CGPoint(
            x: point.x * cos(angle) - point.y * sin(angle),
            y: point.x * sin(angle) + point.y * cos(angle)
        )
    }

    private func particleColor(index: Int, opacity: Double) -> Color {
        switch index % 5 {
        case 0: return .cyan.opacity(opacity)
        case 1: return .pink.opacity(opacity)
        case 2: return .orange.opacity(opacity)
        case 3: return .green.opacity(opacity)
        default: return .yellow.opacity(opacity)
        }
    }

    private func curveColor(layer: Int) -> Color {
        switch layer % 4 {
        case 0: return .cyan
        case 1: return .pink
        case 2: return .orange
        default: return .purple
        }
    }
}

struct MineView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.tint)

            Text("Mine")
                .font(.largeTitle.bold())

            Text("Your personal space.")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
