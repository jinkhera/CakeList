//
//  CakesListDatasource.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation
import UIKit

@objc class CakesDatasource: NSObject, UITableViewDataSource, ImageCacheDelegate {
    
    // MARK: - Types
    
    struct CellIdentifiers {
        static let cake = "CakeCell"
    }
    
    // MARK: - vars
    private weak var tableView: UITableView?
    var cakes = [Cake]()
    
    @objc var imageCache: ImageCache?
    
    // MARK: initialiser
    init(tableView: UITableView, cakes: [Cake]) {
        super.init()
        self.cakes = cakes
        self.tableView = tableView
        configure(tableView: tableView)
    }
    
    // MARK: - private methods
    private func configure(tableView: UITableView) {
        tableView.dataSource = self
    }
    
    // MARK: - update datasource
    func update(cakes: [Cake]) {
        self.cakes.removeAll()
        self.cakes = cakes.sorted(by: { (a, b) -> Bool in
            a.title > b.title
        })
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cake, for: indexPath) as! CakeCell
        let cake = cakes[indexPath.row]
        cell.titleLabel.text = cake.title
        cell.descriptionLabel.text = cake.desc
        
        imageCache?.imageForURL(cake.image, resizeTo: Double(cell.cakeImageView.frame.width), completion: { (image) in
            cell.cakeImageView.image = image
        })
        
        return cell
    }
    
    // MARK: - ImageCacheDelegate
    func imageCacheChanged(imageCahce: ImageCache, imageURL: URL) {
        
    }
    
    func imageCacheChanged(imageCahce: ImageCache, imageURL: URL, image: UIImage?) {
        let updatableCakes = self.cakes.filter { (c) -> Bool in
            c.image == imageURL
        }
        
        let indexPaths = updatableCakes.map { (c) -> IndexPath in
            let index = self.cakes.index(of: c)
            return IndexPath(item: index!, section: 0)
        }
        
        DispatchQueue.main.async {
            self.tableView?.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
}
