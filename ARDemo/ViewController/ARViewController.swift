import UIKit
import RealityKit
import ARKit
import FocusEntity

class ARViewController: UIViewController {
    @IBOutlet weak var arView: ARView!
    var focusSquare: FocusEntity!
    var placeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureARSession()
        setupUI()
    }
    
    private func configureARSession() {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal, .vertical]
            configuration.frameSemantics = .sceneDepth
            
            if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                configuration.sceneReconstruction = .mesh
            }
            
            arView.session.run(configuration)
            
            arView.environment.sceneUnderstanding.options = [.occlusion, .physics]
         
            
            // Initialize FocusEntity
            focusSquare = FocusEntity(on: arView, style: .classic(color: .yellow))
            
            // Add directional light
            let light = DirectionalLight()
            light.light.color = .white
            light.light.intensity = 1000
            light.orientation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0]) // Angled downward
            let lightAnchor = AnchorEntity(world: [0, 1, 0])  // Position light above
            lightAnchor.addChild(light)
            arView.scene.addAnchor(lightAnchor)
        }
    
    private func setupUI() {
        placeButton = UIButton(type: .system)
        placeButton.setTitle("Place Object", for: .normal)
        placeButton.backgroundColor = UIColor.systemBlue
        placeButton.setTitleColor(.white, for: .normal)
        placeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        placeButton.layer.cornerRadius = 10
        placeButton.translatesAutoresizingMaskIntoConstraints = false
        placeButton.addTarget(self, action: #selector(placeObject), for: .touchUpInside)
        
    
        view.addSubview(placeButton)
        
        NSLayoutConstraint.activate([
            placeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            placeButton.widthAnchor.constraint(equalToConstant: 200),
            placeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func placeObject() {
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
