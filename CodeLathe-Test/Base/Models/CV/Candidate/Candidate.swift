//
//  Candidate.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

struct Candidate {
    
    let firstName: String
    let lastName: String
    let emailAddress: String
    let phoneNumber: String
    let bio: String
    
    let gallery: CandidateGallery
    let skills: [CandidateSkill]
    
    init(
        firstName: String,
        lastName: String,
        emailAddress: String,
        phoneNumber: String,
        bio: String,
        gallery: CandidateGallery,
        skills: [CandidateSkill]) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.bio = bio
        
        self.gallery = gallery
        self.skills = skills
        
    }
}
