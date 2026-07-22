<?php
namespace App\Controllers;use App\Core\{Auth,Request,View};use App\Models\{Appointment,Patient};final class DashboardController{public function patient(Request$r):void{View::render('dashboard/patient',['title'=>'Patient Dashboard','user'=>Auth::user(),'nextAppointment'=>Appointment::upcoming(Auth::id()),'recentAppointments'=>array_slice(Appointment::forPatient(Auth::id()),0,4),'unreadCount'=>Patient::unreadCount(Auth::id())]);}public function admin(Request$r):void{View::render('dashboard/admin',['title'=>'Admin Dashboard','user'=>Auth::user()]);}}

