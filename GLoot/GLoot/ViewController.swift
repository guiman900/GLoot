//
//  ViewController.swift
//  GLoot
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit
import GLootNetworkLibrary

class ViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var network: GLootNetwork?
    var players: [GLootPlayer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        network = GLootNetwork()
        network?.delegate = self
        
        network?.getPlayers()
    
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "EditImage"), style: .done, target: self, action: #selector(addTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapped(sender: AnyObject) {
    
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let index = indexPath.section
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            let alert = UIAlertController(title: "Delete Player", message: "Are you sure you want to delete this player?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                if let player = self.players?[index] {
                    self.network?.deletePlayer(playerId: player.id)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {action in
            let alert = UIAlertController(title: "Edit User", message: "Enter a new name for the player.", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
                if let player = self.players?[index] {
                    guard let text = alert.textFields?[0].text else {
                        self.network?.editPlayer(playerId: player.id, playerName: "")
                        return
                    }
                    self.network?.editPlayer(playerId: player.id, playerName: text)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)

        }
        
        return [deleteAction, editAction]
    }

}

extension ViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let players = self.players else {
            return 0
        }
    return players.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.players == nil {
            return 0
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell else {
            return UITableViewCell()
        }
        guard let name = self.players?[indexPath.section] else {
            cell.name.text = "Undefined"
            return cell

        }
        cell.name.text = name.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}


extension ViewController : GLootNetworkProtocol {
    /**
     getPlayers response
     
     - Parameter players: player list.
     */
    public func playersReceived(players: [GLootNetworkLibrary.GLootPlayer])
    {
        print(players)
        self.players = players
        tableView.reloadData()
    }

    /**
     getPlayer response
     
     - Parameter player: the player.
     */
    public func playerReceived(player: GLootNetworkLibrary.GLootPlayer)
    {
        print(player)
    }

    /**
     createPlayer response
     
     - Parameter player: the player created.
     */
    public func playerCreated(player: GLootNetworkLibrary.GLootPlayer)
    {
        print(player)
        self.players?.append(player)
        tableView.reloadData()
    }

    /**
     editPlayer response
     
     - Parameter player: the player edited.
     */
    public func playerEdited(player: GLootNetworkLibrary.GLootPlayer)
    {
        print(player)
        if let index = self.players?.index(where:  { $0.id == player.id }) {
            self.players?[index].name = player.name
            tableView.reloadData()
        }
    }

    /**
     deletePlayer response
     
     - Parameter player: the player deleted.
     */
    public func playerDeleted(player: GLootNetworkLibrary.GLootPlayer)
    {
        print(player)
        if let index = self.players?.index(where:  { $0.id == player.id }) {
            self.players?.remove(at: index)
            tableView.reloadData()
        }
    }

    /**
     Method triggered if an error happend during one of the network operation
     
     - Parameter error: error description.
     */
    public func networkError(error: String)
    {
        print(error)
    }

}

