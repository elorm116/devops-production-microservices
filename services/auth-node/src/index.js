import express from "express";

const app = express();
app.use(express.json());

app.post("/login", (req, res) => {
  res.json({ token: "demo" });
});

app.listen(3000, () => {
  console.log("Auth service running on port 3000");
});
