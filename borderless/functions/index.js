const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "ykmolumo@gmail.com",
    pass: "Adeoye@1590$",
  },
});

exports.sendOTP = functions.https.onCall(async (data, context) => {
  const { email, otp } = data;

  const mailOptions = {
    from: "ykmolumo@gmail.com",
    to: email,
    subject: "Your Borderless Verification OTP",
    text: `Your verification OTP is: ${otp}. Enter this code to verify your account.`,
    html: `<p>Your verification OTP is: <strong>${otp}</strong>. Enter this code to verify your account.</p>`,
  };

  try {
    await transporter.sendMail(mailOptions);
    return { success: true };
  } catch (error) {
    console.error("Error sending email:", error);
    throw new functions.https.HttpsError("internal", "Failed to send OTP.");
  }
});