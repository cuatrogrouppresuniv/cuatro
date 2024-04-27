package com.example.cuatros.model

data class AddComplaint(
    var description: String? = null,
    var location: String? = null,
    var status: String? = null,
    var imageUrl: String? = null,
    var timeStamp: String? = null,
    var userId: String? = null
)