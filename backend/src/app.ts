import express from "express";
import cors from "cors";

import { authMiddleware } from "./middleware/auth.middleware.js";
import { errorMiddleware } from "./middleware/error.middleware.js";

import { authRouter } from "./modules/auth/auth.routes.js";
import { companyRouter } from "./modules/company/company.routes.js";
import { companyMemberRouter } from "./modules/company_member/company_member.routes.js";
import { siteRouter } from "./modules/site/site.routes.js";
import { siteAssignmentRouter } from "./modules/site_assignment/site_assignment.routes.js";
import { taskRouter } from "./modules/task/task.routes.js";
import { dailyReportRouter } from "./modules/daily_report/daily_report.routes.js";
import { taskProgressRouter } from "./modules/task_progress/task_progress.routes.js";
import { proofPhotoRouter } from "./modules/proof_photos/proof_photos.routes.js";
import { issuesRouter } from "./modules/issues/issues.routes.js";

const app = express();

// middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// routes
app.use("/api/v1/auth", authRouter);
app.use("/api/v1/company", authMiddleware, companyRouter);
app.use("/api/v1/company-members", authMiddleware, companyMemberRouter);
app.use("/api/v1/sites", authMiddleware, siteRouter);
app.use("/api/v1/site-assignments", authMiddleware, siteAssignmentRouter);
app.use("/api/v1/tasks", authMiddleware, taskRouter);
app.use("/api/v1/daily-reports", authMiddleware, dailyReportRouter);
app.use("/api/v1/task-progress", authMiddleware, taskProgressRouter);
app.use("/api/v1/proof-photos", authMiddleware, proofPhotoRouter);
app.use("/api/v1/issues", authMiddleware, issuesRouter);

app.get("/health", (_, res) => {
  res.status(200).json({
    success: true,
    message: "Server is healthy",
  });
});

app.use(errorMiddleware);

export default app;

