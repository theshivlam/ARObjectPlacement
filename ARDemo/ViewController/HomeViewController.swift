import UIKit
import SceneKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var arViewButton: UIButton!
    @IBOutlet weak var scnView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constant.Colored.globalScreenColor
        
        // Load Model
        loadModel()
        
        // Setup Scene
        setupSceneView()
    }
    
    @IBAction func arButtonClick(_ sender: Any) {
        guard let arVC = self.storyboard?.instantiateViewController(identifier: Constant.StoryboardID.arViewController) else { return }
        self.navigationController?.pushViewController(arVC, animated: true)
    }
    
    func setupSceneView() {
        
        scnView.backgroundColor = Constant.Colored.globalScreenColor
        
        // Enable default lighting
        scnView.autoenablesDefaultLighting = true
        
        // Set up camera controls
        scnView.defaultCameraController.maximumHorizontalAngle = 0
        scnView.defaultCameraController.minimumHorizontalAngle = 0
        
        scnView.defaultCameraController.maximumVerticalAngle = 50
        scnView.defaultCameraController.minimumVerticalAngle = 0
        
        // Enable default camera controls
        scnView.allowsCameraControl = true
    }
    
    func loadModel() {
        guard let url = Bundle.main.url(forResource: Constant.ModelNames.modelName , withExtension: Constant.ModelExtensio.extensionUsdz) else {
            print("Model not found")
            return
        }
        
        do {
            let file = try SCNScene(url: url)
            scnView.scene = file
            
        } catch {
            print("Cannot load usdz: \(error)")
        }
    }
}
