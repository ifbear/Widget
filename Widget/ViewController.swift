//
//  ViewController.swift
//  Widget
//
//  Created by dexiong on 2023/5/4.
//

import UIKit
import CoreData
import WidgetKit

class ViewController: UIViewController {
    
    private lazy var frc: NSFetchedResultsController = {
        let freq: NSFetchRequest<Record> = Record.fetchRequest()
        freq.sortDescriptors = [.init(key: "timespace", ascending: true)]
        let viewContext = DataBase.shared.viewContext
        let _frc: NSFetchedResultsController = .init(fetchRequest: freq, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        _frc.delegate = self
        return _frc
    }()
    
    private lazy var tableView: UITableView = {
        let _tableView: UITableView = .init(frame: .zero, style: .plain)
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        _tableView.rowHeight = 80
        _tableView.delegate = self
        return _tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID> = .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
        let record = self.frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = record.title
        cell.contentConfiguration = configuration
        return cell
    }
    
    private lazy var addItem: UIBarButtonItem = .init(image: .init(systemName: "plus.square"), style: .plain, target: self, action: #selector(itemActionHandler(_:)))

    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = addItem
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? frc.performFetch()
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension ViewController {
    @objc
    private func itemActionHandler(_ sender: UIBarButtonItem) {
        switch sender {
        case addItem:
            let viewContext: NSManagedObjectContext = frc.managedObjectContext
            viewContext.performAndWait {
                let record = Record(context: viewContext)
                record.title = "\(arc4random())"
                record.timespace = Date()
                record.finish = false
                try? viewContext.save()
            }
            WidgetCenter.shared.reloadAllTimelines()
            
            
        default:
            break
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delAction = UIContextualAction(style: .destructive, title: "删除") { _, view, block in
            let viewContext: NSManagedObjectContext = self.frc.managedObjectContext
            viewContext.performAndWait {
                let obj = self.frc.object(at: indexPath)
                viewContext.delete(obj)
                try? viewContext.save()
            }
            WidgetCenter.shared.reloadAllTimelines()
            block(true)
        }
        let finishAction = UIContextualAction(style: .normal, title: "标记") { _, view, block in
            let viewContext: NSManagedObjectContext = self.frc.managedObjectContext
            viewContext.performAndWait {
                let obj = self.frc.object(at: indexPath)
                obj.finish = true
                try? viewContext.save()
            }
            WidgetCenter.shared.reloadAllTimelines()
            block(true)
        }
        return .init(actions: [delAction, finishAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = frc.object(at: indexPath)
        navigationController?.pushViewController(EditViewController(objectID: obj.objectID), animated: true)
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: true)
    }
}

