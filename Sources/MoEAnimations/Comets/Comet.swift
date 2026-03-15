import UIKit

public struct Comet {
    public let startPoint: CGPoint
    public let endPoint: CGPoint
    public let lineColor: UIColor
    public let cometColor: UIColor

    public init(
        startPoint: CGPoint,
        endPoint: CGPoint,
        lineColor: UIColor = UIColor.white.withAlphaComponent(0.2),
        cometColor: UIColor = UIColor.white
    ) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.lineColor = lineColor
        self.cometColor = cometColor
    }

    public var linePath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }

    public func drawLine() -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 0.5
        lineLayer.strokeColor = lineColor.cgColor
        return lineLayer
    }

    public func animate() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.emitterPosition = startPoint

        let cell = CAEmitterCell()
        cell.contents = contents
        cell.birthRate = 0.2 * Float(Int.random(in: 500...2000)) / 1000
        cell.lifetime = 10.0
        cell.velocity = 600
        cell.velocityRange = 400
        cell.emissionLongitude = calculateAngle()

        emitter.emitterCells = [cell]
        return emitter
    }

    private var contents: Any? {
        let cometLayer = CAGradientLayer()
        cometLayer.colors = [cometColor.withAlphaComponent(0.0).cgColor, cometColor.cgColor]
        cometLayer.cornerRadius = 0.25
        cometLayer.frame = CGRect(x: 0, y: 0, width: 80, height: 0.5)
        cometLayer.locations = [0.0, 1.0]
        cometLayer.startPoint = CGPoint(x: 0, y: 0.5)
        cometLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        UIGraphicsBeginImageContextWithOptions(cometLayer.bounds.size, cometLayer.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        cometLayer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()?
            .rotate(radians: calculateAngle())?
            .cgImage
    }

    public func calculateAngle() -> CGFloat {
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        return atan2(deltaY, deltaX)
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: CGFloat(radians))
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
