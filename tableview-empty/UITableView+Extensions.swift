import UIKit

extension UITableView {
    /// テーブルビューreloadした後の処理のExtension
    ///
    /// - Parameter completion: テーブルびビューreloadした後の処理
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
    }
    
    /// データなしの時表示するメッセージ
    ///
    /// - Parameter message: データなしの時表示するメッセージ
    func showEmpty(_ message: String?) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.numberOfLines = 0;
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    
    /// データなしから回復する時
    func restore() {
        self.backgroundView = nil
    }
}
