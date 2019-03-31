//
//  ViewController.swift
//  CreatePDF
//
//  Created by PiyushVyas on 26/03/19.
//  Copyright © 2019 PiyushVyas. All rights reserved.
//

import UIKit
import PDFKit
import TPPDF

class ViewController: UIViewController {

    let arrUserPhoto : [String] = ["u1",
                                 "u2",
                                 "u3",
                                 "u1",
                                 "u2",
                                 "u3"]
    let arrUserName : [String] = ["AAA",
                                  "BBB",
                                  "CCC",
                                  "AAA",
                                  "BBB",
                                  "CCC"]
    let arrUserSign : [String] = ["s1",
                                  "s2",
                                  "s3",
                                  "s1",
                                  "s2",
                                  "s3"]
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK:-
    func generateExamplePDF() {
        let kPadding : Int = 30
        
        let document = PDFDocument(format: .a4)
        
        // Set document meta data
        document.info.title = "TPPDF Example"
        document.info.subject = "Building a PDF easily"
        document.info.ownerPassword = "Password123"
        
        // Set spacing of header and footer
        document.layout.space.header = 5
        document.layout.space.footer = 5
        
        // Add custom pagination, starting at page 1 and excluding page 3
        /*document.pagination = PDFPagination(container: .footerRight, style: PDFPaginationStyle.customClosure { (page, total) -> String in
            return "\(page) / \(total)"
            }, range: (1, 20), hiddenPages: [3, 7], textAttributes: [
                .font: UIFont.boldSystemFont(ofSize: 15.0),
                .foregroundColor: UIColor.green
            ])*/
        
        //Title
        let title = NSMutableAttributedString(string: "Autonome", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 25.0),
            .foregroundColor: UIColor.black])
        document.addAttributedText(.contentCenter, text: title)
        
        // Create a line separator
        document.addSpace(space: kPadding)
        document.addLineSeparator(style: PDFLineStyle(type: .full, color: UIColor.darkGray, width: 0.5))
        document.addSpace(space: kPadding)
        
        // Create a table
        let table = PDFTable()
        do {
            var arrData : [[Any?]] =  []
            let dicData_Header : [Any?] = ["Sr.No.",
                                           "User Photo",
                                           "User Info",
                                           "User Sign"]
            arrData.removeAll()
            arrData.append(dicData_Header as [Any])
            
            for i in 0 ..< self.arrUserName.count {
                let userPhoto : String = self.arrUserPhoto[i]
                let userName : String = self.arrUserName[i]
                let userSign : String = self.arrUserSign[i]
                
                let dicData : [Any?] = [i+1,
                                        UIImage(named: userPhoto)!,
                                        userName + "\n" + userName,
                                        UIImage(named: userSign)!] as [Any]
                arrData.append(dicData)
            }
            
            //------->Possition
            var arrDataPossition : [[PDFTableCellAlignment]] = []
            let dicData_HeaderPossition : [PDFTableCellAlignment] = [.left, .left, .left, .left]
            
            arrDataPossition.removeAll()
            arrDataPossition.append(dicData_HeaderPossition)
            
            for _ in 0 ..< self.arrUserName.count {
                let dicDataPossition : [PDFTableCellAlignment] = [.center, .center, .left, .center]
                arrDataPossition.append(dicDataPossition)
            }
            
            try table.generateCells(data: arrData,
                                    alignments: arrDataPossition)
            
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        
        // The widths of each column is proportional to the total width, set by a value between 0.0 and 1.0, representing percentage.
        table.widths = [ 0.15, 0.25, 0.35, 0.25 ]
        
        // To speed up table styling, use a default and change it
        let style = PDFTableStyleDefaults.simple
        style.columnHeaderCount = 1
        //style.footerCount = 1
        table.style = style
        do {
            try table.setCellStyle(row: 1, column: 1, style: PDFTableCellStyle(colors: (fill: UIColor.white, text: UIColor.black)))
        } catch PDFError.tableIndexOutOfBounds(let index, let length){
            // In case the index is out of bounds
            print("Requested cell is out of bounds! \(index) / \(length)")
        } catch {
            // General error handling in case something goes wrong.
            print("Error while setting cell style: " + error.localizedDescription)
        }
        
        // Set table padding and margin
        table.padding = 1.0
        table.margin = 1.0
        table.showHeadersOnEveryPage = true
        document.addTable(table: table)
        
        //View PDF
        do {
            // Generate PDF file and save it in a temporary file. This returns the file URL to the temporary file
            let url = try PDFGenerator.generateURL(document: document, filename: "Example.pdf", progress: {
                (progressValue: CGFloat) in
                print("progress: ", progressValue)
            }, debug: false)
            
            // Load PDF into a webview from the temporary file
            //(self.view as? UIWebView)?.loadRequest(URLRequest(url: url))
            print("url - \(url)")
        } catch {
            print("Error while generating PDF: " + error.localizedDescription)
        }
    }
    
    //MARK:-
    @IBAction func btnCreateAction(_ sender: UIButton) {
        self.generateExamplePDF()
    }
    
    @IBAction func btnViewction(_ sender: UIButton) {
        
    }
}

