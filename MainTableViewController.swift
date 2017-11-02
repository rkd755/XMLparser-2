//
//  MainTableViewController.swift
//  Feeding3
//
//  Created by D7702_09 on 2017. 11. 2..
//  Copyright © 2017년 kch. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, XMLParserDelegate {
    let listEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
    
    let detailEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersDetailsInfo"
    
    let serviceKey = "qzlVqmGoLRO5ZJQkCQJoOSAUWMmoWvgxArZ6e5Mw6OXQ7CkfUuiSKVb3t89PfI1oBtbJnWlho2N73nn66aID6g%3D%3D"
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.plist")
        
        if fileManager.fileExists(atPath: url!.path){
            items = NSArray(contentsOf: url!) as! Array
        } else { //파일이 없을 경우
        getList()
        let tempList = items//목록
        items = []
        for tempItem in tempList {
            getDetail(idx: tempItem["idx"]!)
            }
        }
        print(items)
        
        let temp = items as NSArray
        temp.write(to: url!, atomically: true)
    }

    func getList() {
        let str = listEndPoint + "?serviceKey=\(serviceKey)&numOfRows=100"
        
        if let url = URL(string: str) {
            //parser
            if let parser = XMLParser(contentsOf: url){
                parser.delegate = self
                let isSuccess = parser.parse()
                if isSuccess {
                    print("성공")
                } else {
                    print("실패")
                }
            }
        }
    }
    
    func getDetail(idx:String) {
        let str = detailEndPoint + "?serviceKey=\(serviceKey)&idex=\(idx)"
        
        if let url = URL(string: str) {
            //parser
            if let parser = XMLParser(contentsOf: url){
                parser.delegate = self
                let isSuccess = parser.parse()
                if isSuccess {
                    print("성공")
                } else {
                    print("실패")
                }
            }
        }
    }
    
    //메소드 추가
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        key = elementName //key 저장
        if key == "item" {
            item = [:] //아이템이 시작될때 딕너리 생성
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("key : \(key) value : \(string)")
        if item[key] == nil{
        item[key] = string.trimmingCharacters(in: .whitespaces)
        //trimmingCharacters = .whitespaces공백제거
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dic = items[indexPath.row]
        cell.textLabel?.text = dic["name"]
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
