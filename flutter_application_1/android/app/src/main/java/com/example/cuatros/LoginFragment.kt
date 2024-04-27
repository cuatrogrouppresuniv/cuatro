package com.example.cuatros

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.findNavController
import com.example.cuatros.databinding.FragmentFirstBinding
import com.example.cuatros.databinding.LoginActivityBinding
import com.example.cuatros.model.User
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class LoginFragment : Fragment() {
    private lateinit var database: DatabaseReference
    val userList = ArrayList<User>()
    private var _binding: LoginActivityBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        requireActivity().actionBar?.hide()
        _binding = LoginActivityBinding.inflate(inflater, container, false)
        return binding.root

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        database = Firebase.database.reference
        
        (requireActivity() as AppCompatActivity).supportActionBar?.setDisplayHomeAsUpEnabled(false)
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
        binding.loginBtn.setOnClickListener {
            var password = binding.passwordText.text.toString()
            var email = binding.emailText.text.toString()
            var ada = 0

            if ("admin" == email && password == "admin") {
                Toast.makeText(
                    context,
                    "Welcome Admin" ,
                    Toast.LENGTH_SHORT
                ).show()
                ada=1
                findNavController().navigate(R.id.action_LoginFragment_to_AdminFragment)
            }
            if(ada==0) {
                for (user in userList) {
                    if (user.email == email && password == user.password) {
                        Toast.makeText(
                            context,
                            "Welcome " + user.username,
                            Toast.LENGTH_SHORT
                        ).show()
                        ada=1
                        var a = Bundle()
                        a.putString("id", user.userId)
                        findNavController().navigate(R.id.action_LoginFragment_to_MenuFragment, a)
                    }
                }
                if (ada == 0) {
                    Toast.makeText(context, "Incorrect Username or Password ", Toast.LENGTH_SHORT)
                        .show()
                }
            }
        }
        binding.registerBtn.setOnClickListener {
            findNavController().navigate(R.id.action_LoginFragment_to_RegisterFragment)

        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}