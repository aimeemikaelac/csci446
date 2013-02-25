function validateForm()
{
	var feeltext=document.forms["form"]["feeltoday"].value;
	if(feeltext==null || feeltext=="")
	{
		alert("Surely you feel something!");
	}
	return true;
}