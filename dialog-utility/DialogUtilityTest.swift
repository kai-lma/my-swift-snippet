import XCTest

class DialogUtilityTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDialog() {
        let testTitle = "title for test dialog"
        let testMessage = "message for test dialog"
        
        let dialog1 = DialogUtility.dialog(message: testMessage)
        XCTAssertEqual(dialog1.controller?.message, testMessage)
        XCTAssertNil(dialog1.controller?.title)
        XCTAssertEqual(dialog1.controller?.actions.count, 0)
        
        let dialog2 = DialogUtility.dialog(title: testTitle, message: testMessage)
        XCTAssertEqual(dialog2.controller?.message, testMessage)
        XCTAssertEqual(dialog2.controller?.title, testTitle)
        XCTAssertEqual(dialog2.controller?.actions.count, 0)
    }
    
    func testMessageDialog() {
        let testTitle = "title for test dialog"
        let testMessage = "message for test dialog"
        
        let dialog1 = DialogUtility.messageDialog(message: testMessage)
        XCTAssertEqual(dialog1.controller?.message, testMessage)
        XCTAssertNil(dialog1.controller?.title)
        XCTAssertEqual(dialog1.controller?.actions.count, 1)
        XCTAssertEqual(dialog1.controller?.actions.last?.title, "OK")
        
        let dialog2 = DialogUtility.messageDialog(title: testTitle, message: testMessage)
        XCTAssertEqual(dialog2.controller?.message, testMessage)
        XCTAssertEqual(dialog2.controller?.title, testTitle)
        XCTAssertEqual(dialog2.controller?.actions.count, 1)
        XCTAssertEqual(dialog2.controller?.actions.last?.title, "OK")
        XCTAssertEqual(dialog2.controller?.actions.last?.style, .default)
    }
    
    func testAddButton() {
        let testMessage = "message for test button"
        let dialog = DialogUtility.dialog(message: testMessage)
        
        let testButtonTitleA = "testButtonA"
        let newDialogA = dialog.addButton(testButtonTitleA, action: { (action) in })
        XCTAssertEqual(newDialogA.controller?.actions.count, 1)
        XCTAssertEqual(newDialogA.controller?.actions.last?.title, testButtonTitleA)
        XCTAssertEqual(newDialogA.controller?.actions.last?.style, .default)
        XCTAssertEqual(newDialogA, dialog)
        
        let testButtonTitleB = "testButtonB"
        let newDialogB = dialog.addButton(testButtonTitleB, style: .destructive, action: { (action) in })
        XCTAssertEqual(dialog.controller?.actions.count, 2)
        XCTAssertEqual(dialog.controller?.actions.last?.title, testButtonTitleB)
        XCTAssertEqual(dialog.controller?.actions.last?.style, .destructive)
        XCTAssertEqual(newDialogB, dialog)
    }
    
    func testAddCancel() {
        let testMessage = "message for test cancel"
        let dialog1 = DialogUtility.dialog(message: testMessage)
        let newDialogA = dialog1.addCancel()
        XCTAssertEqual(dialog1.controller?.actions.count, 1)
        XCTAssertEqual(dialog1.controller?.actions.last?.title, "キャンセル")
        XCTAssertEqual(dialog1.controller?.actions.last?.style, .cancel)
        XCTAssertEqual(newDialogA, dialog1)
        
        let dialog2 = DialogUtility.dialog(message: testMessage)
        let testButtonTitle = "testCancel"
        let newDialogB = dialog2.addCancel(testButtonTitle, action: { (action) in })
        XCTAssertEqual(dialog2.controller?.actions.count, 1)
        XCTAssertEqual(dialog2.controller?.actions.last?.title, testButtonTitle)
        XCTAssertEqual(dialog2.controller?.actions.last?.style, .cancel)
        XCTAssertEqual(newDialogB, dialog2)
    }
}

fileprivate extension DialogUtility.Dialog {
    var controller: UIAlertController? {
        let mirror = Mirror.init(reflecting: self)
        return mirror.children.first(where: { $0.label == "controller" })?.value as? UIAlertController
    }
}
