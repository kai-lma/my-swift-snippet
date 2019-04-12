import UIKit

/// ダイアログのクラス
class DialogUtility: NSObject {
    
    class Dialog {
        
        private var controller: UIAlertController
        
        /// ダイアログ初期化
        /// - Parameters:
        ///   - title: ダイアログタイトル
        ///   - message: タイアログ文言
        /// - Returns: 作成したダイアログ
        init(title: String? = nil, message: String?) {
            controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        }
        
        /// ダイアログにボタン追加
        /// - Parameters:
        ///   - title: ボタンタイトル
        ///   - style: ボタンスタイル（default: 普通, cancel: キャンセル, destructive: 警告）
        ///   - action: ボタン押した時の処理
        /// - Returns: ダイアログ自体
        func addButton(_ title: String?, style: UIAlertAction.Style = .default, action: ((UIAlertAction) -> Void)?) -> Self {
            controller.addAction(UIAlertAction.init(title: title, style: style, handler: { (alertAction) in
                action?(alertAction)
            }))
            return self
        }
        
        /// ダイアログにキャンセルボタン追加
        /// - Parameters:
        ///   - title: ボタンタイトル（設定しない場合は「キャンセル」）
        ///   - action: ボタン押した時の処理（キャンセルで何もしない場合は設定なしで可能）
        /// - Returns: ダイアログ自体
        func addCancel(_ title: String? = LocalizedString("cancel"), action: ((UIAlertAction) -> Void)? = nil) -> Self {
            return self.addButton(title, style: .cancel, action: action)
        }
        
        /// ダイアログを表示する
        /// - Parameters:
        ///   - viewController: ダイアログ出す画面
        ///   - animated: アニメーションするかどうか（デフォルトはアニメーションする）
        ///   - completion: ダイアログの表示できた時のハンドル
        /// - Returns: ダイアログ自体
        @discardableResult
        func show(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> Self {
            let action = {
                viewController.present(self.controller, animated: animated, completion: completion)
            }
            if Thread.isMainThread {
                action()
            } else {
                DispatchQueue.main.async {
                    action()
                }
            }
            return self
        }
        
    }

    /// ダイアログを作成する
    /// - Parameters:
    ///   - title: ダイアログタイトル
    ///   - message: タイアログ文言
    /// - Returns: 作成したダイアログ
    class func dialog(title: String? = nil, message: String?) -> Dialog {
        return Dialog.init(title: title, message: message)
    }
    
    /// メッセージダイアログを作成する（OKボタン付け）
    /// - Parameters:
    ///   - title: ダイアログタイトル
    ///   - message: タイアログ文言
    /// - Returns: 作成したダイアログ
    class func messageDialog(title: String? = nil, message: String?, action: ((UIAlertAction) -> Void)? = nil) -> Dialog {
        return Dialog.init(title: title, message: message).addButton(LocalizedString("ok"), action: action)
    }
}

extension DialogUtility.Dialog: Equatable {
    static func == (lhs: DialogUtility.Dialog, rhs: DialogUtility.Dialog) -> Bool {
        return lhs.controller == rhs.controller
    }
}
