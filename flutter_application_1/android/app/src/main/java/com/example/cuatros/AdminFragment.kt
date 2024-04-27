package com.example.cuatros

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.cuatros.adapter.ComplaintAdapter
import com.example.cuatros.adapter.ComplaintsAdapter
import com.example.cuatros.databinding.AdminActivityBinding
import com.example.cuatros.databinding.MenuActivityBinding
import com.example.cuatros.model.Complaint
import com.example.cuatros.model.User
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class AdminFragment : Fragment() {
    private lateinit var database: DatabaseReference
    val complaintList = ArrayList<Complaint>()
    val userList = ArrayList<User>()
    private var _binding: AdminActivityBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = AdminActivityBinding.inflate(inflater, container, false)
        return binding.root

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        database = Firebase.database.reference
        (requireActivity() as AppCompatActivity).supportActionBar?.setDisplayHomeAsUpEnabled(false)
        database.child("complaints").get().addOnSuccessListener { dataSnapshot ->
            if (dataSnapshot.exists()) {
                for (userSnapshot in dataSnapshot.children) {
                    val complaint = userSnapshot.getValue(Complaint::class.java)
                    if (complaint != null) {
                        complaint.complaintId = userSnapshot.key
                    }
                    if (complaint != null) {
                        complaintList.add(complaint)
                    }
                }
                // Sekarang, userList berisi semua objek User dari Firebase
                // Anda dapat melakukan operasi yang diperlukan di sini dengan userList
                Log.i("firebase", "Data pengguna berhasil diambil: $complaintList")
                binding.recycle.layoutManager = LinearLayoutManager(context)

                // This will pass the ArrayList to our Adapter
                val adapter = ComplaintsAdapter(complaintList,this)

                // Setting the Adapter with the recyclerview
                binding.recycle.adapter = adapter
            } else {
                Log.i("firebase", "Tidak ada data pengguna yang tersedia")
            }
        }.addOnFailureListener { error ->
            Log.e("firebase", "Gagal mengambil data pengguna", error)
        }
        database.child("users").get().addOnSuccessListener { dataSnapshot ->
            if (dataSnapshot.exists()) {
                for (userSnapshot in dataSnapshot.children) {
                    val user = userSnapshot.getValue(User::class.java)
                    if (user != null) {
                        user.userId = userSnapshot.key
                    }
                    if (user != null) {
                        userList.add(user)
                    }
                }
                // Sekarang, userList berisi semua objek User dari Firebase
                // Anda dapat melakukan operasi yang diperlukan di sini dengan userList
                Log.i("firebase", "Data pengguna berhasil diambil: $complaintList")
            } else {
                Log.i("firebase", "Tidak ada data pengguna yang tersedia")
            }
        }.addOnFailureListener { error ->
            Log.e("firebase", "Gagal mengambil data pengguna", error)
        }




    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}