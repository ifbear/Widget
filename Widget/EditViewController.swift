//
//  EditViewController.swift
//  Widget
//
//  Created by dexiong on 2023/5/5.
//

import UIKit
import CoreData
import WidgetKit

class EditViewController: UIViewController {
    
    private var viewContext: NSManagedObjectContext = DataBase.shared.viewContext

    private let objectID: NSManagedObjectID
    
    private lazy var textView: UITextView = {
        let textView: UITextView = .init(frame: .zero)
        return textView
    }()
    
    private lazy var uiSwitch: UISwitch = {
        let textView: UISwitch = .init(frame: .zero)
        return textView
    }()
    
    private lazy var saveItem: UIBarButtonItem = .init(image: .init(systemName: "highlighter"), style: .plain, target: self, action: #selector(itemActionHandler(_:)))
    
    internal init(objectID: NSManagedObjectID) {
        self.objectID = objectID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = saveItem
        
        view.addSubview(textView)
        view.addSubview(uiSwitch)
        
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewContext.performAndWait {
            let obj: Record = viewContext.object(with: objectID) as! Record
            textView.text = obj.title
            uiSwitch.isOn = obj.finish
        }
    }

    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 200)
        uiSwitch.frame = .init(x: view.bounds.width - 88, y: textView.frame.maxY + 20, width: 88, height: 44)
    }
}

extension EditViewController {
    @objc
    private func itemActionHandler(_ sender: UIBarButtonItem) {
        switch sender {
        case saveItem:
            viewContext.performAndWait {
                let obj: Record = self.viewContext.object(with: self.objectID) as! Record
                obj.title = self.textView.text
                obj.finish = self.uiSwitch.isOn
                obj.timespace = Date()
                try? self.viewContext.save()
            }
            WidgetCenter.shared.reloadAllTimelines()
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
}
