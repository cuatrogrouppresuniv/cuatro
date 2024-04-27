package com.example.cuatros.adapter

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.example.cuatros.MenuFragment
import com.example.cuatros.R
import com.example.cuatros.model.Complaint

class ComplaintAdapter(private val mList: List<Complaint>, menuFragment: MenuFragment, id: String) : RecyclerView.Adapter<ComplaintAdapter.ViewHolder>() {
    var fragment = menuFragment
    var id = id
    // create new views
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        // inflates the card_view_design view
        // that is used to hold list item
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.complaint_list, parent, false)

        return ViewHolder(view)
    }

    // binds the list items to a view
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        val ItemsViewModel = mList[position]

        // sets the image to the imageview from our itemHolder class

        // sets the text to the textview from our itemHolder class
        holder.textView.text = ItemsViewModel.description
        Glide.with(fragment)
            .load(ItemsViewModel.imageUrl)
            .into(holder.imageView)
        holder.textView.setOnClickListener {
            var a = Bundle()
            a.putString("id",id)
            a.putString("id_complaint",ItemsViewModel.complaintId)
            fragment.findNavController().navigate(R.id.action_MenuFragment_to_DetailFragment,a)

        }

    }

    // return the number of the items in the list
    override fun getItemCount(): Int {
        return mList.size
    }

    // Holds the views for adding it to image and text
    class ViewHolder(ItemView: View) : RecyclerView.ViewHolder(ItemView) {
        val imageView: ImageView = itemView.findViewById(R.id.imageview)
        val textView: TextView = itemView.findViewById(R.id.textView)
    }
}