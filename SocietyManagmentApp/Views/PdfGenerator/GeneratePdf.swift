//
//  GeneratePdf.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

@MainActor
func GeneratePdf(maintenance: Maintenance, profile: Profile) -> URL? {
    let pdfView = PdfView(maintenance: maintenance, profile: profile)
    let fileName = "Recipt_\(maintenance.receiptNo ?? "N/A").pdf"
    
    guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
        return nil
    }
    let tempURL = cachesDir.appendingPathComponent(fileName)
    
    
    if #available(iOS 16.0, *) {
        let imageRender = ImageRenderer(content: pdfView)
        
        imageRender.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdfContext = CGContext(tempURL as CFURL, mediaBox: &box, nil) else { return }
            
            pdfContext.beginPDFPage(nil)
            context(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        
        if FileManager.default.fileExists(atPath: tempURL.path) {
            return tempURL
        } else {
            print("Error: PDF rendered context closed, but file was not written to disk.")
            return nil
        }
    } else {
        return nil
    }
}
