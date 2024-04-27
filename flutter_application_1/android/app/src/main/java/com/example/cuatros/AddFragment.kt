package com.example.cuatros

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Toast
import androidx.navigation.fragment.findNavController
import com.example.cuatros.databinding.AddComplaintActivityBinding
import com.example.cuatros.databinding.FragmentFirstBinding
import com.example.cuatros.databinding.LoginActivityBinding
import com.example.cuatros.databinding.RegisterActivityBinding
import com.example.cuatros.model.Complaint
import com.example.cuatros.model.User
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.FirebaseStorage
import android.app.Dialog
import android.content.Context
import android.graphics.Bitmap
import android.provider.MediaStore
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class AddFragment : Fragment() {
    private lateinit var database: DatabaseReference
    private lateinit var storageReference: FirebaseStorage
    private lateinit var id: String
    private val REQUEST_IMAGE_CAPTURE = 2

    private lateinit var  dialog : Dialog
    private lateinit var uri: Uri
    private lateinit var imageUrl: String
    private val PICK_IMAGE_REQUEST = 1

    private var _binding: AddComplaintActivityBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = AddComplaintActivityBinding.inflate(inflater, container, false)
        return binding.root

    }
    fun getCurrentDateTime(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
        val currentTime = Date()
        return dateFormat.format(currentTime)
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        storageReference = FirebaseStorage.getInstance()
        id = arguments?.getString("id").toString()
        dialog = context?.let { Dialog(it) }!!
        database = Firebase.database.reference
        binding.addBtn.setOnClickListener {
            showLoadingDialog()
            var location = binding.LocationText.text.toString()
            var description = binding.descriptionTxt.text.toString()
            val fileRef = storageReference.reference.child("images/${System.currentTimeMillis()}.jpg")

            fileRef.putFile(uri)
                .addOnSuccessListener {
                    // Gambar berhasil diunggah, dapatkan URL gambar
                    fileRef.downloadUrl.addOnSuccessListener { downloadUri ->
                        imageUrl = downloadUri.toString()

                        // Sekarang Anda dapat menyimpan URL gambar ini ke Firebase Database atau melakukan apa pun yang Anda inginkan dengannya
                        // Contoh: simpan URL gambar ke Firebase Database
                        // FirebaseDatabase.getInstance().getReference("images").push().setValue(imageUrl)
                        var ada = 0
                        val data = Complaint(
                            location  = location,
                            description = description,
                            userId = id,
                            imageUrl = imageUrl,
                            timeStamp = getCurrentDateTime(),
                            status = "Pending"
                        )
                        database.child("complaints").push().setValue(data)
                        Toast.makeText(context,"Successfuly Adding Complaint", Toast.LENGTH_SHORT).show()
                        var a = Bundle()
                        a.putString("id",id)
                        dismissLoadingDialog()
                        findNavController().navigate(R.id.action_AddFragment_to_MenuFragment,a)
                    }
                }
                .addOnFailureListener { e ->
                    Toast.makeText(context, "Failed to upload image: ${e.message}", Toast.LENGTH_SHORT).show()
                }


        }
        binding.addImg.setOnClickListener {
            captureImage()
        }
        binding.addImg1.setOnClickListener {
            selectImageFromGallery()
        }
    }
    private fun captureImage() {
        Intent(MediaStore.ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
            takePictureIntent.resolveActivity(requireContext().packageManager)?.also {
                startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
            }
        }
    }

    private fun selectImageFromGallery() {
        val intent = Intent()
        intent.type = "image/*"
        intent.action = Intent.ACTION_GET_CONTENT
        startActivityForResult(Intent.createChooser(intent, "Select Picture"), PICK_IMAGE_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == PICK_IMAGE_REQUEST && resultCode == Activity.RESULT_OK && data != null && data.data != null) {
            uri = data.data!!

            // Menampilkan gambar yang dipilih
            binding.imageView.setImageURI(uri)

            // Panggil method untuk mengunggah gambar ke Firebase Storage
            //
        } else if (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == Activity.RESULT_OK) {
            val imageBitmap = data?.extras?.get("data") as Bitmap
            uri = saveImageToInternalStorage(imageBitmap)
            binding.imageView.setImageURI(uri)
        }
    }

    private fun saveImageToInternalStorage(bitmap: Bitmap): Uri {
        val file = File(requireContext().cacheDir, "${System.currentTimeMillis()}.jpg")

        try {
            val stream: OutputStream = FileOutputStream(file)
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
            stream.flush()
            stream.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }

        return Uri.fromFile(file)
    }

    fun showLoadingDialog() {
        dialog.setContentView(R.layout.loading)
        dialog.setCancelable(false) // Prevent dialog from being dismissed by touching outside

        // Adjust dialog size if needed
        val width = WindowManager.LayoutParams.WRAP_CONTENT
        val height = WindowManager.LayoutParams.WRAP_CONTENT
        dialog.window?.setLayout(width, height)

        dialog.show()
    }
    fun dismissLoadingDialog() {
        dialog.dismiss()
    }



    private fun uploadImageToFirebase(uri: Uri) {
        val fileRef = storageReference.reference.child("images/${System.currentTimeMillis()}.jpg")

        fileRef.putFile(uri)
            .addOnSuccessListener {
                // Gambar berhasil diunggah, dapatkan URL gambar
                fileRef.downloadUrl.addOnSuccessListener { downloadUri ->
                    imageUrl = downloadUri.toString()

                    // Sekarang Anda dapat menyimpan URL gambar ini ke Firebase Database atau melakukan apa pun yang Anda inginkan dengannya
                    // Contoh: simpan URL gambar ke Firebase Database
                    // FirebaseDatabase.getInstance().getReference("images").push().setValue(imageUrl)

                    Toast.makeText(context, "Image uploaded successfully", Toast.LENGTH_SHORT).show()
                }
            }
            .addOnFailureListener { e ->
                Toast.makeText(context, "Failed to upload image: ${e.message}", Toast.LENGTH_SHORT).show()
            }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}