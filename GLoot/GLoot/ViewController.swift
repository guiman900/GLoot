//
//  ViewController.swift
//  GLoot
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import AVFoundation
import UIKit
import GLootNetworkLibrary

/**
 TableView cell used on the ViewController
 */
class ViewController: UIViewController {
    // - Mark: properties

    @IBOutlet weak var playerImage: UIImageView!
    /// player name, used on the player view for edit.
    @IBOutlet weak var playerName: UITextField!
    /// tab bar containing the add player button
    @IBOutlet weak var tabBar: UITabBar!
    /// tableView containing the players
    @IBOutlet weak var tableView: UITableView!
    /// player view, displaying the player information / edit the player name
    @IBOutlet weak var playerView: UIView!
    /// video player view
    @IBOutlet weak var videoPlayerView: UIView!
    
    /// GLoot network
    internal var network: GLootNetwork?
    
    /// List of players
    internal var players: [GLootPlayer]?
    /// selected user on the playerView
    internal var selectedPlayer: GLootPlayer?
    
    /// color of the status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// video player for the transition
    var videoPlayer: AVPlayer?
    
    
    // - Mark: Methods
    /**
     Called after the controller's view is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network = GLootNetwork()
        network?.delegate = self
        
        network?.getPlayers()
        
        self.initViewWithBlur()
        playVideo()

    }

    /**
     Sent to the view controller when the app receives a memory warning.
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Play the video for the transition
    */
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "page", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
            
        }
        
        self.videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = self.view.frame
        self.videoPlayerView.layer.addSublayer(playerLayer)
        videoPlayer?.play()
            
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {self.videoPlayerView.removeFromSuperview()}, completion: nil)
    }
}

/**
 UITbabBar delegate
 */
extension ViewController: UITabBarDelegate {
    /**
     Sent to the delegate when the user selects a tab bar item.
     
     - Parameter tabBar: The tab bar that is being customized.
     - Parameter item: The tab bar item that was selected.
     */
    internal func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
            let alert = UIAlertController(title: "Add User", message: "Enter a name for the new player.", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
                
                    guard let text = alert.textFields?[0].text else {
                        self.network?.createPlayer(playerName: "")
                        return
                    }
                    self.network?.createPlayer(playerName: text)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            tabBar.selectedItem = nil
    }
}

extension ViewController: UITableViewDelegate {
    /**
     Asks the data source to verify that the given row is editable.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     Asks the data source to commit the insertion or deletion of a specified row in the receiver.
     
     - Parameter tableView: The table-view object requesting the insertion or deletion.
     - Parameter editingStyle: The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are insert or delete.
     - Parameter indexPath: An index path locating the row in tableView.
    */
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    /**
     Asks the delegate for the actions to display in response to a swipe in the specified row.
     
     - Parameter tableView: The table view object requesting this information.
     - Parameter indexPath: The index path of the row.
     */
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
        deleteAction.backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 48/255, alpha: 1)

        
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
        
        editAction.backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 48/255, alpha: 1)

        return [deleteAction, editAction]
    }

    /**
     Tells the delegate that the specified row is now selected.
     
     - Parameter tableView: A table-view object informing the delegate about the new row selection.
     - Parameter indexPath: An index path locating the new selected row in tableView.
    */
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlayer = self.players?[indexPath.section]
        self.addContactView()
    }
}

/**
 UITableView Data Source
 */
extension ViewController: UITableViewDataSource {
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
    */
    internal func numberOfSections(in tableView: UITableView) -> Int {
        guard let players = self.players else {
            return 0
        }
        return players.count
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
    */
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.players == nil {
            return 0
        }
        return 1
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    /**
     Asks the delegate for the height to use for the header of a particular section.
     This method allows the delegate to specify section headers with varying heights.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section of tableView .
    */
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    /**
     Asks the delegate for a view object to display in the header of the specified section of the table view.
     
     - Parameter tableView: The table-view object asking for the view object.
     - Parameter section: An index number identifying a section of tableView .
    */
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

/**
 ViewController Extension managing the PlayerView
 */
extension ViewController {
    
    /**
     Create a blut effect on the playerView.
     */
    internal func initViewWithBlur()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.addSubview(blurEffectView)
        blurEffectView.sendSubview(toBack: playerView)
        playerView.sendSubview(toBack: blurEffectView)
        
        /* resize the playerView for the Ipad / Iphone Screen */
        var rect :CGRect = self.view.frame
        rect.origin.x = 0
        rect.origin.y = 0
        self.playerView.frame = rect
        
        self.playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /**
     Add the playerView with a transition
     */
    internal func addContactView()
    {
        self.playerName.text = selectedPlayer?.name
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {self.view.addSubview(self.playerView)}, completion: nil)
        
    }
    
    /**
     remove the playerView with a transition
     */
    internal func removePlayerView()
    {
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {self.playerView.removeFromSuperview()}, completion: nil)
    }
    
    /**
     Method triggered when the user ckick on the close / cancel button
     
     - Parameter sender: The close button.
    */
    @IBAction func closePlayerView(_ sender: UIButton) {
        self.removePlayerView()
        self.selectedPlayer = nil
    }
    
    /**
     Method triggered when the user ckick on the save button
     
     - Parameter sender: The save button.
     */
    @IBAction func saveChanges(_ sender: UIButton) {
        self.removePlayerView()
        
        if let id = selectedPlayer?.id, let name = self.playerName.text {
            self.network?.editPlayer(playerId: id, playerName: name)
        }
        
        self.selectedPlayer = nil
    }
    
    /**
     Method triggered when the user ckick on the delete button
     
     - Parameter sender: The delete button.
     */
    @IBAction func deleteUser(_ sender: UIButton) {
        self.removePlayerView()

        if let id = selectedPlayer?.id {
            self.network?.deletePlayer(playerId: id)
        }
        
        self.selectedPlayer = nil
    }

    
}

/**
 Asynchronus delegate of the GLootNetworkLibrary
 */
extension ViewController : GLootNetworkProtocol {
    /**
     getPlayers response
     
     - Parameter players: player list.
     */
    internal func playersReceived(players: [GLootNetworkLibrary.GLootPlayer])
    {
        print(players)
        self.players = players
        tableView.reloadData()
    }

    /**
     getPlayer response
     
     - Parameter player: the player.
     */
    internal func playerReceived(player: GLootNetworkLibrary.GLootPlayer)
    {
        print(player)
    }

    /**
     createPlayer response
     
     - Parameter player: the player created.
     */
    internal func playerCreated(player: GLootNetworkLibrary.GLootPlayer)
    {
        print(player)
        self.players?.append(player)
        tableView.reloadData()
    }

    /**
     editPlayer response
     
     - Parameter player: the player edited.
     */
    internal func playerEdited(player: GLootNetworkLibrary.GLootPlayer)
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
    internal func playerDeleted(player: GLootNetworkLibrary.GLootPlayer)
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
    internal func networkError(error: String)
    {
        print(error)
    }

}

