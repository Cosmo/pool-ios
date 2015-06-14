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
    var userLabel:          UILabel
    var amountLabel:        UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.nameLabel          = UILabel()
        self.userLabel          = UILabel()
        self.amountLabel          = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.userLabel)
        self.contentView.addSubview(self.amountLabel)
        
        self.amountLabel.textAlignment = NSTextAlignment.Right
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.frame        = CGRect(x: 15, y: 12, width: self.frame.size.width - 15 - 15, height: 16)
        self.userLabel.frame        = CGRect(x: 15, y: 12+15+12, width: self.frame.size.width - 15 - 15, height: 16)
        self.amountLabel.frame        = CGRect(x: 15, y: 12+15+12, width: self.frame.size.width - 15 - 15, height: 16)
    }
}

class ActivityUserViewCell: UITableViewCell {
    var nameLabel:          UILabel
    var amountLabel:          UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.nameLabel          = UILabel()
        self.amountLabel          = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
        
        self.amountLabel.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(self.amountLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.frame        = CGRect(x: 15, y: 0, width: self.frame.size.width - 15 - 15, height: self.frame.size.height)
        self.amountLabel.frame      = CGRect(x: 15, y: 0, width: self.frame.size.width - 15 - 15, height: self.frame.size.height)
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
        if let id = _id {
            let viewController = UINavigationController(rootViewController: AddTransactionViewController(id: id))
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    func addFriend(sender: AnyObject) {
        if let id = _id {
            let viewController = UINavigationController(rootViewController: InviteViewController(id: id))
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let count = self.data?.users?.count {
                return count
            } else {
                return 0
            }
        case 2:
            if let count = self.data?.transactions?.count {
                return count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44.0
        case 1:
            return 44.0
        case 2:
            return 68.0
        default:
            return 44.0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Total"
        case 1:
            return "Friends"
        case 2:
            return "Transactions"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // FIX THIS
            var cell: ActivityUserViewCell
            cell = tableView.dequeueReusableCellWithIdentifier(activityUserCell, forIndexPath: indexPath) as! ActivityUserViewCell
            
            if
                let amountInCents = self.data?.total?.amount,
                let currency = self.data?.total?.currency
            {
                let amount = Double(amountInCents) / 100.0
                let numberFormatter             = NSNumberFormatter()
                numberFormatter.numberStyle     = NSNumberFormatterStyle.CurrencyStyle
                numberFormatter.currencyCode    = currency
                
                cell.textLabel?.text = numberFormatter.stringFromNumber(amount)
            }
            
            
            
            return cell
        } else if indexPath.section == 1 {
            var cell: ActivityUserViewCell
            cell = tableView.dequeueReusableCellWithIdentifier(activityUserCell, forIndexPath: indexPath) as! ActivityUserViewCell
            if let user = self.data?.users?[indexPath.row] {
                cell.nameLabel.text = user.name
                
                if
                    let amountInCents = user.amount
                    // should be fixed
//                    ,
//                    let currency = user.currency
                {
                    let currency = "eur"
                    let amount = Double(amountInCents) / 100.0
                    let numberFormatter             = NSNumberFormatter()
                    numberFormatter.numberStyle     = NSNumberFormatterStyle.CurrencyStyle
                    numberFormatter.currencyCode    = currency
                    
                    cell.amountLabel.text = numberFormatter.stringFromNumber(amount)
                }
                
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
                
                cell.amountLabel.text = numberFormatter.stringFromNumber(amount)
            }
            
            cell.userLabel.text = self.data?.transactions?[indexPath.row].user
            cell.nameLabel.text = self.data?.transactions?[indexPath.row].name
            
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