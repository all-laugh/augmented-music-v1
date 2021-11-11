//
//  PageControl.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/10/21.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    
    var numPages: Int
    var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.backgroundStyle = .minimal
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        control.numberOfPages = numPages
        control.currentPage = currentPage
            
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
   
}
