import UIKit

public class AUNV {
    public class func present(from vc: UIViewController) {
        let nc = UINavigationController(rootViewController: ViewerViewController())
        nc.navigationBar.isHidden = true
        nc.modalPresentationStyle = .fullScreen
        vc.present(nc, animated: true)
    }
}
