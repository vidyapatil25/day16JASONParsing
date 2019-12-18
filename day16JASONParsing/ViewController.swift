//
//  ViewController.swift
//  day16JASONParsing
//
//  Created by Felix-ITS016 on 18/12/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var  finalArray = [String]()
    var  finalEmailArray = [String]()
    enum  JsonErrors:String,Error
    {
        case responseError = "Response Error"
        case dataError = "Data Error"
        case ConversionError = "Conversion Error"
    }
    
    func Parsejson()
    {
        let urlString = "https://api.github.com/repositories/19436/commits"
        let url:URL = URL(string: urlString)!
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession( configuration:sessionConfiguration)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            do
            {
                guard let  response = response else
               {
                throw JsonErrors.responseError
                }
                guard let data = data else
                {
                   throw JsonErrors.dataError
                }
                guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else
                {
                    throw JsonErrors.ConversionError
                }
                for item in array
                {
                    let commitDic = item["commit"] as! [String:Any]
                    let authorDic = commitDic["author"] as! [String:Any]
                    let name = authorDic["name"] as! String
                    print(name)
                    self.finalArray.append(name)
                    let email = authorDic["email"] as! String
                    print(email)
                    self.finalEmailArray.append(email)
                }
                if self.finalArray.count>0
                {
                    DispatchQueue.main.async {
                         self.tableView.reloadData()
                    }
                   
                }
            }
           catch let err
           {
            print(err)
            }
        }
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return finalArray.count
        }
        else
        {
            return finalEmailArray.count
            
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        if indexPath.section == 0
        {
            cell.textLabel?.text = finalArray[indexPath.row]
             cell.detailTextLabel?.text = finalEmailArray [indexPath.row]
        }
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Parsejson()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

