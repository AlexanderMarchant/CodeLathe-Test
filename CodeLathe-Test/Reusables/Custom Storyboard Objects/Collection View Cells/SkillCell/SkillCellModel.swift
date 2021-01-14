//
//  SkillCellModel.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation


class SkillCellModel {
    
    let skill: String
    
    init(_ candidateSkill: CandidateSkill) {
        self.skill = candidateSkill.skill
    }
    
}
