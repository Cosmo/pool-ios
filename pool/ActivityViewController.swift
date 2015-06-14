//
//  ActivityViewController.swift
//  
//
//  Created by Devran Uenal on 13.06.15.
//
//

import UIKit

class ActivityTransactionViewCell: UITableViewCell {
    var nameLabel:          UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.nameLabel          = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.frame        = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}

class ActivityUserViewCell: UITableViewCell {
    var nameLabel:          UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.nameLabel          = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.frame        = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}



class ActivityViewController: UITableViewController {
    let activityTransactionCell = "activityTransactionCell"
    let activityUserCell        = "activityUserCell"
    var data:   Activity?
    var _id:    String?
    
    init(id: String) {
        self._id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(ActivityUserViewCell.self, forCellReuseIdentifier: activityUserCell)
        self.tableView.registerClass(ActivityTransactionViewCell.self, forCellReuseIdentifier: activityTransactionCell)
        
        self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addTransaction:"),
                UIBarButtonItem(title: "Invite", style: UIBarButtonItemStyle.Plain, target: self, action: "addFriend:")
        ]
        
        if let id = _id {
            Activity.detail(id)?.success({ (data, response) -> () in
                var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
                self.data <-- stringData
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.title = self.data?.name
                })
            }).failure({ (data, response, error) -> () in
                println("failure")
            }).call()
        }
        
    }
    
    func addTransaction(sender: AnyObject) {
        let viewController = UINavigationController(rootViewController: AddTransactionViewController())
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func addFriend(sender: AnyObject) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = self.data?.users?.count {
                return count
            } else {
                return 0
            }
        case 1:
            if let count = self.data?.transactions?.count {
                return count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Friends"
        case 1:
            return "Transactions"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell: ActivityUserViewCell
            cell = tableView.dequeueReusableCellWithIdentifier(activityUserCell, forIndexPath: indexPath) as! ActivityUserViewCell
            if let user = self.data?.users?[indexPath.row] {
                cell.textLabel?.text = user.name
            }
            return cell
        } else {
            var cell: ActivityTransactionViewCell
            cell = tableView.dequeueReusableCellWithIdentifier(activityTransactionCell, forIndexPath: indexPath) as! ActivityTransactionViewCell
            if
                let transaction = self.data?.transactions?[indexPath.row],
                let amountInCents = transaction.amount,
                let currency = transaction.currency
            {
                let amount = Double(amountInCents) / 100.0
                let numberFormatter             = NSNumberFormatter()
                numberFormatter.numberStyle     = NSNumberFormatterStyle.CurrencyStyle
                numberFormatter.currencyCode    = currency
                
                cell.textLabel?.text = numberFormatter.stringFromNumber(amount)
            }
            return cell
        }
    }
    
}

















/*
class ActivityViewController: UICollectionViewController {
    let transactionCell = "transactionCell"
    let userCell        = "userCell"
    let data:       Activity?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: transactionCell)
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: userCell)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = self.data?.users?.count {
                return count
            } else {
                return 0
            }
        case 1:
            if let count = self.data?.transactions?.count {
                return count
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(transactionCell, forIndexPath: indexPath) as! UICollectionViewCell
    
        // Configure the cell
    
        return cell
    }
}
*/