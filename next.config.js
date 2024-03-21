/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
    images: {
	loader: 'akamai',
	path: "",
	domains: ['cdn.vox-cdn.com'],
  },
};

module.exports = nextConfig;
