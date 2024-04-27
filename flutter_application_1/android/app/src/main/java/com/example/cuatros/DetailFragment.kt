package com.example.cuatros

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.bumptech.glide.Glide
import com.example.cuatros.adapter.ComplaintAdapter
import com.example.cuatros.databinding.DetailActivityBinding
import com.example.cuatros.databinding.MenuActivityBinding
import com.example.cuatros.model.Complaint
import com.example.cuatros.model.User
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class DetailFragment : Fragment() {
    private lateinit var database: DatabaseReference
    private lateinit var id: String
    private lateinit var complaint_id: String
    val complaintList = ArrayList<Complaint>()
    val userList = ArrayList<User>()
    private var _binding: DetailActivityBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = DetailActivityBinding.inflate(inflater, container, false)
        return binding.root

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        id = arguments?.getString("id").toString()
        complaint_id = arguments?.getString("id_complaint").toString()
        Log.i("firebase", id)
        database = Firebase.database.reference
        database.child("complaints").get().addOnSuccessListener { dataSnapshot ->
            if (dataSnapshot.exists()) {
                for (userSnapshot in dataSnapshot.children) {
                    val complaint = userSnapshot.getValue(Complaint::class.java)
                    if (complaint != null) {
                        complaint.complaintId = userSnapshot.key
                    }
                    if (complaint != null) {
                        if (complaint.complaintId==complaint_id){
                            binding.locationText.text = "Location : "+complaint.location
                            binding.descriptionTxt.text = "Description : "+complaint.description
                            binding.timeStampTxt.text = "Create At : "+complaint.timeStamp
                            binding.statusTxt.text = "Status : "+complaint.status
                            Glide.with(this)
                                .load(complaint.imageUrl)
                                .into(binding.imageView2)
                        }
                    }
                }
            } else {
                Log.i("firebase", "Tidak ada data pengguna yang tersedia")
            }
        }.addOnFailureListener { error ->
            Log.e("firebase", "Gagal mengambil data pengguna", error)
        }




        binding.deleteBtn.setOnClickListener {
            database.child("complaints").child(complaint_id).removeValue()
            Toast.makeText(context,"Successfuly Deleted Complaint", Toast.LENGTH_SHORT).show()
            var a = Bundle()
            a.putString("id",id)
            findNavController().navigate(R.id.action_DetailFragment_to_MenuFragment,a)

        }

    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}