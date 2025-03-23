import UIKit
import RealityKit
import ARKit
import FocusEntity

class ARViewController: UIViewController {
    @IBOutlet weak var arView: ARView!
    var focusSquare: FocusEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigureARSession()
        
    }
    
    private func ConfigureARSession(){
        let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = [.horizontal, .vertical]
                arView.session.run(configuration)
 
        // Initialize FocusEntity
        focusSquare = FocusEntity(on: arView, style: .classic(color: .yellow))
        
        // Add a tap gesture recognizer to place objects
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        // Add directional light
        let light = DirectionalLight()
        light.light.color = .white
        light.light.intensity = 1000
        light.orientation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0]) // Angled downward
        let lightAnchor = AnchorEntity(world: [0, 1, 0])  // Position light above
        lightAnchor.addChild(light)
        arView.scene.addAnchor(lightAnchor)
    }
    
    @objc func handleTap() {
           guard let position = focusSquare?.position else { return }
           
           // Load a 3D model and place it at the focus square's position
           let anchorEntity = AnchorEntity(world: position)
        let modelEntity = try! ModelEntity.loadModel(named: Constant.ModelNames.modelName)
        
           anchorEntity.addChild(modelEntity)
           arView.scene.addAnchor(anchorEntity)
        
            // Play the first animation
            playAnimation(for: modelEntity)
       }
    
    func playAnimation(for modelEntity: ModelEntity) {
        guard let animationResource = modelEntity.availableAnimations.first else {
            print("No animation resource found.")
            return
        }
        
        // Play the animation with specified parameters
        modelEntity.playAnimation(animationResource.repeat(duration: .infinity),
                                   transitionDuration: 1.25,
                                   startsPaused: false)
    }
}
