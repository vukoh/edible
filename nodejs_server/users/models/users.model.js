const mongoose = require('mongoose');
mongoose.connect("mongodb+srv://vuKoh:vuKoh2019$@edible-kegh0.gcp.mongodb.net/test?retryWrites=true&w=majority");
const Schema = mongoose.Schema;

const userSchema = new Schema({
    firstName: String,
    lastName: String,
    email: String,
    dietaryRestriction: String,
    password: String,
    permissionLevel: Number
 });

 const User = mongoose.model('Users', userSchema);

 exports.createUser = (userData) => {
    const user = new User(userData);
    return user.save();
};

exports.findById = (id) => {
    return User.findById(id).then((result) => {
        result = result.toJSON();
        delete result._id;
        delete result.__v;
        return result;
    });
};
