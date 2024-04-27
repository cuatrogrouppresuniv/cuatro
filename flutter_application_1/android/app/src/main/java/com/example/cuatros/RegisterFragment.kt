package com.example.cuatros

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import com.example.cuatros.databinding.FragmentFirstBinding
import com.example.cuatros.databinding.LoginActivityBinding
import com.example.cuatros.databinding.RegisterActivityBinding
import com.example.cuatros.model.User
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class RegisterFragment : Fragment() {
    private lateinit var database: DatabaseReference
    val userList = ArrayList<User>()

    private var _binding: RegisterActivityBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = RegisterActivityBinding.inflate(inflater, container, false)
        return binding.root

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        database = Firebase.database.reference
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
                Log.i("firebase", "Data pengguna berhasil diambil: $userList")
            } else {
                Log.i("firebase", "Tidak ada data pengguna yang tersedia")
            }
        }.addOnFailureListener { error ->
            Log.e("firebase", "Gagal mengambil data pengguna", error)
        }
        binding.registerBtn.setOnClickListener {
            var username = binding.UsernameText.text.toString()
            var password = binding.passwordText.text.toString()
            var email = binding.emailText.text.toString()
            var ada = 0
            for(user in userList){
                if(user.email==email){
                    Toast.makeText(context,"Email Already Registered", Toast.LENGTH_SHORT).show()
                    ada = 1
                }
            }
            if(ada==0){
                val data = User(
                username = username,
                email = email,
                password = password
                )
                database.child("users").push().setValue(data)
                Toast.makeText(context,"Registration Success", Toast.LENGTH_SHORT).show()
                findNavController().navigate(R.id.action_RegisterFragment_to_LoginFragment)
            }



        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}