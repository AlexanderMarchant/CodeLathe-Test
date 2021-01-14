//
//  SkillsCollectionViewDataSource.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

class SkillsCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView
    let candidateSkills: [CandidateSkill]
    
    init(
        candidateSkills: [CandidateSkill],
        collectionView: UICollectionView) {
        
        self.candidateSkills = candidateSkills
        self.collectionView = collectionView
        
        self.collectionView.backgroundColor = .clear
        
//        let alignedLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
//        alignedLayout.minimumInteritemSpacing = Constants.goalCollectionViewCellSpacing
//        alignedLayout.minimumLineSpacing = Constants.goalCollectionViewCellSpacing
//        alignedLayout.scrollDirection = .vertical
//        collectionView.collectionViewLayout = alignedLayout
        
        collectionView.register(
            UINib.init(
                nibName: Constants.skillCellNibName,
                bundle: nil),
            forCellWithReuseIdentifier: Constants.skillCellIdentifier)
        
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidateSkills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.skillCellIdentifier,
            for: indexPath) as! SkillCell
        
        
        if(candidateSkills.count - 1 < indexPath.row) {
            return cell
        }
        
        let candidateSkill = candidateSkills[indexPath.row]
        
        let skillCellModel = SkillCellModel(candidateSkill)
        
        cell.model = skillCellModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (self.candidateSkills[indexPath.item].skill as NSString).size(withAttributes: [NSAttributedString.Key.font: Fonts.headerFont])
        
        return CGSize(
            width: (size.width + Constants.skillCellWidthPadding),
            height: (size.height + Constants.skillCellHeightPadding)
        )
    }
}

